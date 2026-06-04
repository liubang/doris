# lz4 compatibility wrapper for Doris
# Doris uses #include <lz4/lz4.h> style includes
# Built via CMake with headers installed under lz4/ subdirectory

load("@rules_foreign_cc//foreign_cc:defs.bzl", "cmake")

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
)

cmake(
    name = "lz4_compat",
    build_args = ["-j"],
    cache_entries = {
        "CMAKE_BUILD_TYPE": "Release",
        "BUILD_SHARED_LIBS": "OFF",
        "BUILD_STATIC_LIBS": "ON",
        "LZ4_BUILD_CLI": "OFF",
        "LZ4_BUILD_LEGACY_LZ4C": "OFF",
        # Install headers into include/lz4/ so they're accessible as <lz4/lz4.h>
        "CMAKE_INSTALL_INCLUDEDIR": "include/lz4",
    },
    # lz4's CMakeLists.txt is in build/cmake/
    working_directory = "build/cmake",
    lib_source = ":all_srcs",
    out_static_libs = ["liblz4.a"],
)
