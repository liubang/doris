# Doris BE 构建系统改造笔记（个人 fork / 学习研究向）

> 目标：将 BE 的外部依赖从 CMake（`thirdparty.cmake` + `build-thirdparty.sh` + `vars.sh`）
> 逐步迁移到 Bazel 全托管，优先手写 BUILD，必要时升级依赖甚至改 Doris 源码配合。
> CMake 老体系**暂不删除**，留作正确性验证的黄金对照基准，待 Bazel 全绿后再拆除。

---

## 阶段 0：基线与差距清单（进行中）

### 0.1 环境基线

- Bazel：8.7.0（mise 管理），`.bazelrc` + `.bazelversion` 已就位
- BE 构建入口：`//be/src:doris_be_lib`（单体 `cc_library`，迁移初期策略，尚无 `cc_binary`）
- 首次全量构建 action 数 ~2549，有缓存后 ~1186

### 0.2 Bazel 化程度（远超预期，已到中后期）

- **FE（Java）**：Maven 依赖 100% 由 `MODULE.bazel` 的 `rules_jvm_external` 托管，有 `maven_install.json` 锁文件
- **BE（C++）依赖三分天下**：
  1. **BCR 直接拉**（~30+ 个稳定库）：abseil、boost 全家（30+ 模块）、zlib、zstd、lz4、snappy、
     brotli、curl、boringssl、flatbuffers、nlohmann_json、simdjson、c-ares、crc32c、icu、
     re2、glog、gflags、googletest 等。少数带 `single_version_override` 打 patch。
  2. **手写 BUILD + http_archive**（`third_party/cpp/extensions.bzl` + `build_defs/*.BUILD`，36 个）：
     fmt、protobuf_21、brpc、thrift_cpp、arrow、orc、rocksdb、jemalloc、libunwind、gperftools、
     libevent、librdkafka、hyperscan、vectorscan、croaring、s2geometry、clucene、openssl、
     leveldb、rapidjson、parallel_hashmap、cctz、pdqsort、concurrentqueue、xxhash、sse2neon、
     fast_float、cpp_timsort、aws_sdk、libbase64、streamvbyte、lz4_compat、bitshuffle、
     libdivide、pugixml 等。
  3. **CMake 老体系**（`be/cmake/thirdparty.cmake`，80+ 个 `add_thirdparty`）：仍并行存在。

### 0.3 BE Bazel 构建状态

- 首次构建未发现编译错误（error），仅有大量 deprecated warning（icu、boost.filesystem 等）
- 90s 限时内进度达 1364/2549，过半且无报错 → **构建链路大概率健康，瓶颈是首次全量编译耗时**
- 后台完整构建运行中（日志 `/tmp/doris_bazel_build.log`），待确认能否产出最终库

### 0.4 ⚠️ 重大发现：patch 对齐情况

两套体系 patch 总量对比：CMake 侧 52 个，Bazel 侧 21 个。差异**大部分是合理的**
（BCR 换版本/换编译方式后很多 patch 不再需要：thrift、glog、libuuid、mysql、krb5、
libhdfs3、flatbuffers、grpc、cyrus-sasl 等）。已对齐的关键库：arrow(3)、orc(3)、cctz(2)、
clucene(2)、rocksdb(1)、vectorscan(1)、re2(2)、snappy(1)、bitshuffle(1)、libdivide(1)。

**唯一的高风险缺口 —— brpc：**

| 体系 | brpc patch 数 | 内容 |
|------|--------------|------|
| CMake | 16 | 见下方完整列表 |
| Bazel | **1** | 仅 `brpc-1.4.0-write-background.patch` |

CMake 侧 16 个 brpc patch，Bazel 侧缺失 15 个，按风险分类：

**A. 深度魔改（缺失会导致行为不一致，必须补）**
- `brpc-1.4.0-no-pthread_mutex-hook.patch`（禁用锁竞争 profiler，420 行，注释 "disabled by doris"）
- `brpc-1.9.0-add-gc-on-abalist-and-adjust-gc-size.patch`（bthread 内存 GC 调优，281 行）

**B. 功能性修复（需逐个判断是否仍需要）**
- `brpc-1.4.0-fix-stream-rpc-set-connected.patch`
- `brpc-1.6.0-fix-core-when-enable-SSL.patch`
- `brpc-1.6.0-Force-SSL-for-all-connections-of-Acceptor.patch`
- `brpc-1.7.0-Server-support-ALPN-with-OpenSSL.patch`
- `brpc-1.8.0-mbvar-format-issue.patch`
- `brpc-2560-Refactor-Socket-SetFailed-...patch`
- `brpc-stream-check-connected.patch`
- `brpc-task_control_parking_slot.patch`
- `brpc-uuid-string.patch`
- `brpc-1.4.0-secondary-package-name.patch`
- `brpc-1.5.0-remove-wordexp.patch`

**C. 编译器适配（新工具链下可能已不需要，待验证）**
- `brpc-1.4.0-clang16.patch`
- `brpc-1.4.0-gcc13.patch`

> 行动项：阶段 2 必须逐个核实 A/B 类 patch 是否需要补进 Bazel 的 brpc `http_archive`，
> 并验证 Bazel 版 brpc 与 CMake 版的行为一致性。

---

## 阶段 0 结论

全量 `bazel build //be/src:doris_be_lib` 已通过（EXIT_CODE=0，~2549 actions 首次 / ~1160 有缓存）。
BE 构建链路健康，可进入阶段 1 逐库改写。

---

## 阶段 1：foreign_cc → 手写 cc_library 逐库改写

### 1.1 已完成：lz4_compat ✅

**改写前**：`rules_foreign_cc` 的 `cmake()` 黑盒，完整跑一遍 cmake configure + make，
仅为把头文件装到 `include/lz4/` 子目录。

**改写后**：纯 `cc_library`，2.6 秒编译（vs cmake 黑盒 ~30s+），全量端到端验证通过。

**可复制模板（lz4_compat 模式）**：

```
适用场景：源码少（< 10 个 .c/.cc）、无 configure/config.h 生成、
          仅需解决 include 路径映射问题的库。

关键技巧：
1. strip_include_prefix + include_prefix 组合
   - strip_include_prefix = "lib"   → 剥掉源码目录前缀
   - include_prefix = "lz4"         → 加上对外暴露前缀
   - 效果：源码 lib/lz4.h → 对外 <lz4/lz4.h>

2. textual_hdrs 处理 #include "xxx.c" 的坑
   - 某些库（如 lz4hc.c）用 #include "lz4.c" 内联源码
   - 把被 include 的 .c 文件加入 textual_hdrs（不影响独立编译）

3. 库内部头放 srcs 而非 hdrs
   - 不需要对外暴露的内部头（如 lz4frame_static.h）放 srcs
   - 只有用户需要 #include 的头才放 hdrs

4. 验证流程
   - 先单独 bazel build @xxx//:target 确认库本身编译通过
   - 再 bazel build //be/src:doris_be_lib 端到端验证
```

### 1.2 已完成：croaring（CRoaring 2.1.2）✅

**改写前**：`rules_foreign_cc` 的 `cmake()` 黑盒。
**改写后**：纯 `cc_library`，20 个 .c 编译 action，critical path 0.9 秒。端到端验证通过。

**关键技巧（croaring 模式 —— 多目录 include 映射）**：

```
适用场景：头文件已在正确的子目录结构中（如 include/roaring/），
          但有额外的头文件在其他目录（如 cpp/）需要映射到同一前缀。

方案：拆分为多个 cc_library target：
1. croaring_c：编译 src/ 下源码，includes = ["include"] → 对外暴露 <roaring/...>
2. croaring_cpp_hdrs：hdrs = cpp/*.hh，strip_include_prefix="cpp" + include_prefix="roaring"
   → 把 cpp/roaring.hh 映射为 <roaring/roaring.hh>
3. croaring：聚合 target，deps = [croaring_c, croaring_cpp_hdrs]

注意：roaring64map.hh 内部用 #include "roaring.hh"（相对路径），
strip_include_prefix 后两个文件在同一虚拟根下，相对 include 仍有效。

ARM 平台：local_defines select 加 ROARING_DISABLE_X64=1。
```

### 1.3 已完成：streamvbyte 1.0.0 ✅

**改写前**：`rules_foreign_cc` 的 `cmake()` 黑盒。
**改写后**：纯 `cc_library`，7 个 .c 编译 action，critical path 0.44 秒。端到端验证通过。

**关键技巧（streamvbyte 模式 —— textual include .c 文件 + 平台条件编译）**：

```
适用场景：源码通过 #include "xxx_arm.c" / "xxx_x64.c" 条件内联平台特定实现，
          不应独立编译这些被 include 的 .c 文件。

方案：
1. srcs 只列 CMake 实际编译的 7 个主 .c 文件
2. textual_hdrs 列所有被 #include 的 .c 文件 + 内部 .h 文件
   （streamvbyte_x64_encode.c, streamvbyte_arm_encode.c, ...）
3. includes = ["include"] 暴露公共头
4. ARM 平台：local_defines select 加 __ARM_NEON__

Doris include 方式：<streamvbyte.h>（无前缀），直接 includes=["include"] 即可。
```

### 1.4 已完成：libbase64（aklomp/base64 0.5.2）✅

**改写前**：`rules_foreign_cc` 的 `cmake()` 黑盒。
**改写后**：纯 `cc_library`，genrule 生成 config.h + 9 个独立 codec target。端到端验证通过（1226 actions）。

**关键技巧（libbase64 模式 —— genrule config.h + per-file SIMD copt）**：

```
适用场景：库通过 config.h 控制功能开关，且不同源文件需要不同的编译标志
         （如 -mssse3, -mavx2, -mavx512vl 等 SIMD 指令集）。

方案：
1. genrule 生成 lib/config.h（输出到 lib/ 子目录，匹配源码 #include "config.h" 搜索路径）
   - select(@platforms//cpu:aarch64) → 只启用 NEON64
   - //conditions:default (x86_64) → 启用所有 SSE/AVX

2. 每个 SIMD codec 独立 cc_library（per-file copt）：
   - codec_generic（无特殊 copt，所有平台）
   - codec_neon64（ARM64 only，无额外 copt，NEON 是 ARM 默认）
   - codec_ssse3（-mssse3）、codec_sse41（-msse4.1）、codec_avx（-mavx）...
   - 非当前平台的 codec 用 select 设 srcs=[]（空编译）

3. textual_hdrs 列所有被 #include 的 .c 文件 + genrule 输出
   - 各 arch 下的 enc_loop.c, dec_loop.c 等都是 textual include
   - ":gen_config_h" 也加入 textual_hdrs（让 Bazel 知道依赖关系）

4. copts 中用 -iquote$(GENDIR)/external/+cpp_deps+libbase64/lib 让
   #include "config.h" 能找到生成的文件

5. _INTERNAL_HDRS 必须包含 include/libbase64.h，因为 codec.c 用
   相对路径 #include "../../../include/libbase64.h" 引用它，
   Bazel 需要知道这个依赖才会把文件放入 sandbox

Doris include 方式：<libbase64.h>（无前缀），includes=["include"] 即可。
Doris patch：base64_encode → do_base64_encode（http_archive patches 已处理）。
```

### 1.5 阶段 1 进度汇总

| 库 | 状态 | 模式 | 编译时间 |
|----|------|------|----------|
| lz4_compat | ✅ 完成 | strip_include_prefix + include_prefix | 2.6s |
| croaring | ✅ 完成 | 多 target include 映射 | 0.9s critical path |
| streamvbyte | ✅ 完成 | textual_hdrs + platform select | 0.44s |
| libbase64 | ✅ 完成 | genrule config.h + per-file SIMD copt | 0.17s critical path |
| bitshuffle | ⏭️ 跳过 | 已是手写 cc_library（非 foreign_cc） | - |
| jemalloc | 待做 | configure_make，需生成 config | - |

**剩余 foreign_cc 黑盒**（按难度排序）：
- 中等：leveldb、libevent、gperftools
- 困难：jemalloc、libunwind、openssl、brpc、thrift、arrow、orc、rocksdb、aws_sdk 等
