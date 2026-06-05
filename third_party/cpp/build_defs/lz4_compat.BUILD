# lz4 compatibility wrapper for Doris —— 手写 cc_library 版（替代原 rules_foreign_cc cmake）
#
# 背景：
#   Doris 源码使用 `#include <lz4/lz4.h>` / `<lz4/lz4hc.h>` / `<lz4/lz4frame.h>`，
#   带 `lz4/` 前缀。而 BCR 的 @lz4 头文件暴露为 `<lz4.h>`（无前缀），不匹配。
#   原方案用 rules_foreign_cc 的 cmake() 重新完整编译一遍 lz4，仅为把头文件装到
#   include/lz4/ 子目录 —— 为了一个 include 路径，拖了一次完整的 configure+make。
#
# 本方案：
#   直接用原生 cc_library 编译 lz4 源码，并用 include_prefix = "lz4" 把对外头文件
#   重映射为 `lz4/*.h`。好处：
#     1) 消除一次完整 cmake 构建（无 configure / 无失控的 make -j）；
#     2) 全部 action 受 Bazel 统一调度与缓存；
#     3) 精确满足 Doris 的 `<lz4/...>` include 需求。
#
# 注意：lz4 的 .c 文件内部用同目录 `#include "lz4.h"`（无前缀），不受 include_prefix
#       影响（include_prefix 只改变“对外暴露”的路径，不影响库内相对 include）。

load("@rules_cc//cc:defs.bzl", "cc_library")

package(default_visibility = ["//visibility:public"])

cc_library(
    name = "lz4_compat",
    srcs = [
        "lib/lz4.c",
        "lib/lz4hc.c",
        "lib/lz4frame.c",
        # 库内部头（被 .c include，但不对外暴露为 lz4/ 前缀，故放 srcs）
        "lib/lz4frame_static.h",
        "lib/xxhash.c",
        "lib/xxhash.h",
    ],
    hdrs = [
        "lib/lz4.h",
        "lib/lz4hc.h",
        "lib/lz4frame.h",
    ],
    # 关键坑：lz4hc.c 用 `#include "lz4.c"`（注意是 .c）把整个 lz4.c 文本内联进来，
    # 以内联 LZ4_count 等内部函数。必须把 lz4.c 声明为 textual_hdr，使其对 lz4hc.c
    # 可见且“可被文本包含而不被独立当作编译单元的对外头”。
    # 注意：lz4.c 已在 srcs 里独立编译一次；textual 包含走的是 lz4hc.c 内部的
    # static/inline 版本，二者符号不冲突（lz4hc.c 内联的是 static 函数）。
    textual_hdrs = [
        "lib/lz4.c",
    ],
    # 先剥掉源码里的 lib/ 目录层级……
    strip_include_prefix = "lib",
    # ……再统一加上 lz4/ 前缀 → 对外暴露为 <lz4/lz4.h> 等，精确匹配 Doris 源码。
    include_prefix = "lz4",
    visibility = ["//visibility:public"],
)
