# Hyperscan 5.4.2 / Vectorscan 5.4.11 - High-performance regex engine
# Built via CMake using rules_foreign_cc
# NOTE: On ARM platforms, Vectorscan should be used instead.

load("@rules_foreign_cc//foreign_cc:defs.bzl", "cmake")

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
)

cmake(
    name = "hyperscan",
    build_args = ["-j"],
    cache_entries = {
        "CMAKE_BUILD_TYPE": "Release",
        "BUILD_SHARED_LIBS": "OFF",
        "BUILD_STATIC_LIBS": "ON",
        "FAT_RUNTIME": "OFF",
    },
    lib_source = ":all_srcs",
    out_static_libs = [
        "libhs.a",
        "libhs_runtime.a",
    ],
    deps = [
        "@boost.algorithm//:boost.algorithm",
    ],
)
