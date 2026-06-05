# LevelDB 1.23 - Embedded key-value store
# 手写 cc_library 版（替代原 rules_foreign_cc cmake）
#
# 背景：
#   LevelDB 是 Google 的嵌入式 KV 存储引擎。在 Doris 中作为 brpc 的依赖。
#   CMake 构建主要做两件事：
#   1. 特性检测生成 port/port_config.h（5 个宏）
#   2. 编译 ~26 个 .cc 文件为 libleveldb.a
#
# 本方案：
#   1. genrule 生成 port/port_config.h（Linux/macOS 不同）
#   2. 单个 cc_library 编译所有源文件
#
# 注意事项：
#   - Doris 禁用了 snappy 和 crc32c 支持
#   - 源文件通过 http_archive 的 patch_cmds 被移到了 _src/ 子目录中，
#     避免 leveldb 的 util/histogram.h 等内部头文件通过 Bazel 的 -iquote
#     泄漏到下游，与 Doris 的同名头文件冲突。

load("@rules_cc//cc:defs.bzl", "cc_library")

package(default_visibility = ["//visibility:public"])

# =============================================================================
# Step 1: 生成 port/port_config.h
# =============================================================================

genrule(
    name = "gen_port_config_h",
    outs = ["port/port_config.h"],
    cmd = select({
        "@platforms//os:macos": """
cat > $@ << 'EOF'
#ifndef STORAGE_LEVELDB_PORT_PORT_CONFIG_H_
#define STORAGE_LEVELDB_PORT_PORT_CONFIG_H_

// macOS: no fdatasync, has F_FULLFSYNC, has O_CLOEXEC
#if !defined(HAVE_FDATASYNC)
#define HAVE_FDATASYNC 0
#endif

#if !defined(HAVE_FULLFSYNC)
#define HAVE_FULLFSYNC 1
#endif

#if !defined(HAVE_O_CLOEXEC)
#define HAVE_O_CLOEXEC 1
#endif

#if !defined(HAVE_CRC32C)
#define HAVE_CRC32C 0
#endif

#if !defined(HAVE_SNAPPY)
#define HAVE_SNAPPY 0
#endif

#endif  // STORAGE_LEVELDB_PORT_PORT_CONFIG_H_
EOF
""",
        # Linux: has fdatasync, no F_FULLFSYNC, has O_CLOEXEC
        "//conditions:default": """
cat > $@ << 'EOF'
#ifndef STORAGE_LEVELDB_PORT_PORT_CONFIG_H_
#define STORAGE_LEVELDB_PORT_PORT_CONFIG_H_

#if !defined(HAVE_FDATASYNC)
#define HAVE_FDATASYNC 1
#endif

#if !defined(HAVE_FULLFSYNC)
#define HAVE_FULLFSYNC 0
#endif

#if !defined(HAVE_O_CLOEXEC)
#define HAVE_O_CLOEXEC 1
#endif

#if !defined(HAVE_CRC32C)
#define HAVE_CRC32C 0
#endif

#if !defined(HAVE_SNAPPY)
#define HAVE_SNAPPY 0
#endif

#endif  // STORAGE_LEVELDB_PORT_PORT_CONFIG_H_
EOF
""",
    }),
)

# =============================================================================
# Step 2: 源文件和头文件
# =============================================================================
# 注意：所有源文件路径都以 _src/ 为前缀，因为 http_archive 的 patch_cmds
# 把 db/, helpers/, port/, table/, util/ 都移到了 _src/ 下。

_SRCS = [
    # db/
    "_src/db/builder.cc",
    "_src/db/c.cc",
    "_src/db/db_impl.cc",
    "_src/db/db_iter.cc",
    "_src/db/dbformat.cc",
    "_src/db/dumpfile.cc",
    "_src/db/filename.cc",
    "_src/db/log_reader.cc",
    "_src/db/log_writer.cc",
    "_src/db/memtable.cc",
    "_src/db/repair.cc",
    "_src/db/table_cache.cc",
    "_src/db/version_edit.cc",
    "_src/db/version_set.cc",
    "_src/db/write_batch.cc",
    # table/
    "_src/table/block.cc",
    "_src/table/block_builder.cc",
    "_src/table/filter_block.cc",
    "_src/table/format.cc",
    "_src/table/iterator.cc",
    "_src/table/merger.cc",
    "_src/table/table.cc",
    "_src/table/table_builder.cc",
    "_src/table/two_level_iterator.cc",
    # util/
    "_src/util/arena.cc",
    "_src/util/bloom.cc",
    "_src/util/cache.cc",
    "_src/util/coding.cc",
    "_src/util/comparator.cc",
    "_src/util/crc32c.cc",
    "_src/util/env.cc",
    "_src/util/env_posix.cc",
    "_src/util/filter_policy.cc",
    "_src/util/hash.cc",
    "_src/util/logging.cc",
    "_src/util/options.cc",
    "_src/util/status.cc",
    # helpers/
    "_src/helpers/memenv/memenv.cc",
]

# 内部头文件（不对外暴露，但编译需要）
_INTERNAL_HDRS = [
    # db/
    "_src/db/builder.h",
    "_src/db/db_impl.h",
    "_src/db/db_iter.h",
    "_src/db/dbformat.h",
    "_src/db/filename.h",
    "_src/db/log_format.h",
    "_src/db/log_reader.h",
    "_src/db/log_writer.h",
    "_src/db/memtable.h",
    "_src/db/skiplist.h",
    "_src/db/snapshot.h",
    "_src/db/table_cache.h",
    "_src/db/version_edit.h",
    "_src/db/version_set.h",
    "_src/db/write_batch_internal.h",
    # table/
    "_src/table/block.h",
    "_src/table/block_builder.h",
    "_src/table/filter_block.h",
    "_src/table/format.h",
    "_src/table/iterator_wrapper.h",
    "_src/table/merger.h",
    "_src/table/two_level_iterator.h",
    # util/
    "_src/util/arena.h",
    "_src/util/coding.h",
    "_src/util/crc32c.h",
    "_src/util/hash.h",
    "_src/util/histogram.h",
    "_src/util/logging.h",
    "_src/util/mutexlock.h",
    "_src/util/no_destructor.h",
    "_src/util/posix_logger.h",
    "_src/util/random.h",
    "_src/util/env_posix_test_helper.h",
    # port/
    "_src/port/port.h",
    "_src/port/port_stdcxx.h",
    "_src/port/thread_annotations.h",
    # helpers/
    "_src/helpers/memenv/memenv.h",
]

# 公共头文件（对外暴露为 <leveldb/xxx.h>）
# include/ 目录没有被移动，仍在仓库根
_PUBLIC_HDRS = [
    "include/leveldb/c.h",
    "include/leveldb/cache.h",
    "include/leveldb/comparator.h",
    "include/leveldb/db.h",
    "include/leveldb/dumpfile.h",
    "include/leveldb/env.h",
    "include/leveldb/export.h",
    "include/leveldb/filter_policy.h",
    "include/leveldb/iterator.h",
    "include/leveldb/options.h",
    "include/leveldb/slice.h",
    "include/leveldb/status.h",
    "include/leveldb/table.h",
    "include/leveldb/table_builder.h",
    "include/leveldb/write_batch.h",
]

# =============================================================================
# Step 3: 内部编译目标（不对外暴露头文件）
# =============================================================================
#
# 两层 target 设计：
#   leveldb_internal - 编译所有源文件，生成 .a，但不暴露 hdrs 给下游
#   leveldb          - 公共 API target，暴露 include/leveldb/*.h 给下游
#
# 源文件在 _src/ 子目录中，通过 -iquote _src 让内部 #include "util/xxx.h"
# 等相对路径能正确解析。仓库根目录下不再有 util/、db/ 等目录，
# 因此即使 Bazel 把仓库根加入下游 -iquote，也不会找到冲突的头文件。

cc_library(
    name = "leveldb_internal",
    srcs = _SRCS + _INTERNAL_HDRS + _PUBLIC_HDRS,
    textual_hdrs = [":gen_port_config_h"],
    copts = [
        "-w",  # 与原 cmake 配置一致：CMAKE_CXX_FLAGS = "-w"
        # 让源文件中的 #include "db/xxx.h"、"util/xxx.h" 等能找到 _src/ 下的文件
        "-iquote$(BINDIR)/external/+cpp_deps+leveldb/_src",
        "-iquoteexternal/+cpp_deps+leveldb/_src",
        # 让 #include "port/port_config.h" 能找到生成的文件
        "-iquote$(GENDIR)/external/+cpp_deps+leveldb",
        # 让 #include "leveldb/db.h" 能找到 include/ 下的公共头文件
        "-Iexternal/+cpp_deps+leveldb/include",
    ],
    local_defines = [
        "LEVELDB_COMPILE_LIBRARY",
        "LEVELDB_PLATFORM_POSIX=1",
        "LEVELDB_HAS_PORT_CONFIG_H=1",
    ],
    linkopts = ["-lpthread"],
    visibility = ["//visibility:private"],
)

# =============================================================================
# Step 4: 公共 API target
# =============================================================================

cc_library(
    name = "leveldb",
    hdrs = _PUBLIC_HDRS,
    strip_include_prefix = "include",
    # implementation_deps 确保 leveldb_internal 的 quote_includes（仓库根目录）
    # 不会传递给下游依赖者，从而避免 -iquote 路径泄漏。
    # 但 leveldb_internal 的库文件（.a）仍然会传递给下游用于链接。
    implementation_deps = [":leveldb_internal"],
    visibility = ["//visibility:public"],
)
