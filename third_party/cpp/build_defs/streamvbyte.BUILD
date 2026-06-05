# streamvbyte 1.0.0 - Fast integer compression —— 手写 cc_library 版
#
# 背景：
#   Doris 源码使用 `#include <streamvbyte.h>`（无前缀），头文件在 include/ 下。
#   源码有 x64 和 ARM 两套 SIMD 实现，通过 #include "xxx_arm_encode.c" /
#   "xxx_x64_encode.c" 条件编译内联（textual include .c 文件模式）。
#
# 注意：
#   - CMake 只编译 7 个主 .c 文件，其余 _arm_*.c / _x64_*.c 是被 textual include 的
#   - ARM 平台需要 -D__ARM_NEON__ 定义
#   - streamvbytedelta.c 是旧版文件，CMake 不编译（已拆分为 _encode/_decode）

load("@rules_cc//cc:defs.bzl", "cc_library")

package(default_visibility = ["//visibility:public"])

cc_library(
    name = "streamvbyte",
    srcs = [
        "src/streamvbyte_encode.c",
        "src/streamvbyte_decode.c",
        "src/streamvbyte_zigzag.c",
        "src/streamvbytedelta_encode.c",
        "src/streamvbytedelta_decode.c",
        "src/streamvbyte_0124_encode.c",
        "src/streamvbyte_0124_decode.c",
    ],
    hdrs = [
        "include/streamvbyte.h",
        "include/streamvbyte_zigzag.h",
        "include/streamvbytedelta.h",
    ],
    # 被主 .c 文件 textual include 的平台特定实现 + 内部头
    textual_hdrs = [
        "src/streamvbyte_x64_encode.c",
        "src/streamvbyte_x64_decode.c",
        "src/streamvbyte_arm_encode.c",
        "src/streamvbyte_arm_decode.c",
        "src/streamvbytedelta_x64_encode.c",
        "src/streamvbytedelta_x64_decode.c",
        "src/streamvbyte_isadetection.h",
        "src/streamvbyte_shuffle_tables_encode.h",
        "src/streamvbyte_shuffle_tables_decode.h",
        "src/streamvbyte_shuffle_tables_0124_encode.h",
        "src/streamvbyte_shuffle_tables_0124_decode.h",
    ],
    includes = ["include"],
    copts = [
        "-std=c99",
        # 源码内部用 #include "streamvbyte_isadetection.h" 等引号形式引用
        # src/ 下的内部头。Bazel 沙箱中源文件和 textual_hdrs 在同一目录，
        # 引号 include 的相对搜索应该能找到。若不行则需加 -iquote。
    ],
    local_defines = select({
        "@platforms//cpu:aarch64": ["__ARM_NEON__"],
        "//conditions:default": [],
    }),
    visibility = ["//visibility:public"],
)
