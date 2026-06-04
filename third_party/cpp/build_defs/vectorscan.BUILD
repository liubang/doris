# Vectorscan 5.4.11 - Portable fork of Hyperscan for ARM/non-x86 platforms
# API/ABI compatible with Hyperscan 5.4.x
# Built via CMake using rules_foreign_cc

load("@rules_foreign_cc//foreign_cc:defs.bzl", "cmake")

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
)

cmake(
    name = "vectorscan",
    build_args = ["-j"],
    cache_entries = {
        "CMAKE_BUILD_TYPE": "Release",
        "BUILD_SHARED_LIBS": "OFF",
        "BUILD_STATIC_LIBS": "ON",
        "FAT_RUNTIME": "OFF",
        "BUILD_BENCHMARKS": "OFF",
        "BUILD_EXAMPLES": "OFF",
        "BUILD_UNIT": "OFF",
    },
    lib_source = ":all_srcs",
    out_static_libs = [
        "libhs.a",
        "libhs_runtime.a",
    ],
    deps = [
        "@boost.algorithm//:boost.algorithm",
        "@boost.container//:boost.container",
        "@boost.dynamic_bitset//:boost.dynamic_bitset",
        "@boost.graph//:boost.graph",
        "@boost.icl//:boost.icl",
        "@boost.multi_array//:boost.multi_array",
        "@boost.random//:boost.random",
    ],
)
