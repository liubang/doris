# CRoaring 2.1.2 - Roaring Bitmaps
# Built via CMake using rules_foreign_cc

load("@rules_foreign_cc//foreign_cc:defs.bzl", "cmake")

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
)

cmake(
    name = "croaring",
    build_args = ["-j"],
    cache_entries = {
        "CMAKE_BUILD_TYPE": "Release",
        "BUILD_SHARED_LIBS": "OFF",
        "ROARING_BUILD_LTO": "OFF",
        "ENABLE_ROARING_TESTS": "OFF",
    },
    lib_source = ":all_srcs",
    out_static_libs = ["libroaring.a"],
)
