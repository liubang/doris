# LevelDB 1.23 - Embedded key-value store
# Built via CMake using rules_foreign_cc
# Note: snappy/crc32c disabled here since they're BCR native targets
# and can't easily be passed to cmake. LevelDB works fine without them.

load("@rules_foreign_cc//foreign_cc:defs.bzl", "cmake")

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
)

cmake(
    name = "leveldb",
    build_args = ["-j"],
    cache_entries = {
        "CMAKE_BUILD_TYPE": "Release",
        "BUILD_SHARED_LIBS": "OFF",
        "LEVELDB_BUILD_TESTS": "OFF",
        "LEVELDB_BUILD_BENCHMARKS": "OFF",
        "HAVE_SNAPPY": "OFF",
        "HAVE_CRC32C": "OFF",
        "CMAKE_CXX_FLAGS": "-w",
    },
    lib_source = ":all_srcs",
    out_static_libs = ["libleveldb.a"],
)
