# CRoaring 2.1.2 - Roaring Bitmaps —— 手写 cc_library 版（替代原 rules_foreign_cc cmake）
#
# 背景：
#   Doris 源码使用 `#include <roaring/roaring.hh>` / `<roaring/roaring64map.hh>`，
#   带 `roaring/` 前缀。CRoaring 源码结构：
#     - C 头文件在 include/roaring/ 下（内部 include 也用 <roaring/...>）
#     - C++ 头文件在 cpp/ 下（roaring.hh、roaring64map.hh）
#     - C 源码在 src/ 下
#   CMake install 时会把 cpp/*.hh 装到 include/roaring/，使用户可以 <roaring/roaring.hh>。
#
# 本方案：
#   1. C 库：直接编译 src/ 下源码，include/ 作为 include path
#   2. C++ 头：用 strip_include_prefix + include_prefix 把 cpp/*.hh 映射为 <roaring/*.hh>
#   3. 合并为一个对外 target :croaring

load("@rules_cc//cc:defs.bzl", "cc_library")

package(default_visibility = ["//visibility:public"])

# C 核心库：编译所有 .c 源码，头文件在 include/ 下
cc_library(
    name = "croaring_c",
    srcs = [
        "src/array_util.c",
        "src/bitset.c",
        "src/bitset_util.c",
        "src/containers/array.c",
        "src/containers/bitset.c",
        "src/containers/containers.c",
        "src/containers/convert.c",
        "src/containers/mixed_andnot.c",
        "src/containers/mixed_equal.c",
        "src/containers/mixed_intersection.c",
        "src/containers/mixed_negation.c",
        "src/containers/mixed_subset.c",
        "src/containers/mixed_union.c",
        "src/containers/mixed_xor.c",
        "src/containers/run.c",
        "src/isadetection.c",
        "src/memory.c",
        "src/roaring.c",
        "src/roaring_array.c",
        "src/roaring_priority_queue.c",
        # 内部头（仅 src 内部使用，不对外暴露）
        "src/license-comment.h",
    ],
    hdrs = glob(["include/**/*.h"]),
    # include/ 作为 include root → 对外暴露为 <roaring/xxx.h>
    includes = ["include"],
    copts = [
        "-std=c11",
    ],
    # ARM (Apple Silicon / Linux aarch64) 不需要 x86 特定优化
    local_defines = select({
        "@platforms//cpu:aarch64": ["ROARING_DISABLE_X64=1"],
        "//conditions:default": [],
    }),
    visibility = ["//visibility:private"],
)

# C++ 头文件库：把 cpp/ 下的 .hh 映射为 <roaring/roaring.hh> 等
# roaring64map.hh 内部用 #include "roaring.hh"（相对路径），
# 两个文件在同一 cpp/ 目录下，strip_include_prefix="cpp" 后
# 它们在同一虚拟根下，相对 include 仍然有效。
cc_library(
    name = "croaring_cpp_hdrs",
    hdrs = [
        "cpp/roaring.hh",
        "cpp/roaring64map.hh",
    ],
    strip_include_prefix = "cpp",
    include_prefix = "roaring",
    deps = [":croaring_c"],
    visibility = ["//visibility:private"],
)

# 对外统一入口
cc_library(
    name = "croaring",
    deps = [
        ":croaring_c",
        ":croaring_cpp_hdrs",
    ],
    visibility = ["//visibility:public"],
)
