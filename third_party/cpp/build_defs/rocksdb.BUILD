# RocksDB 5.14.2 - Embedded key-value store
# Built via CMake using rules_foreign_cc

load("@rules_foreign_cc//foreign_cc:defs.bzl", "cmake")

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
)

cmake(
    name = "rocksdb",
    build_args = ["-j"],
    cache_entries = {
        "CMAKE_BUILD_TYPE": "Release",
        "WITH_TESTS": "OFF",
        "WITH_BENCHMARK_TOOLS": "OFF",
        "WITH_TOOLS": "OFF",
        "WITH_GFLAGS": "OFF",
        "WITH_SNAPPY": "ON",
        "WITH_LZ4": "ON",
        "WITH_ZLIB": "ON",
        "WITH_ZSTD": "ON",
        "PORTABLE": "ON",
        "FAIL_ON_WARNINGS": "OFF",
    },
    install_args = ["--component", "devel"],
    lib_source = ":all_srcs",
    out_static_libs = ["librocksdb.a"],
    targets = ["rocksdb"],
    deps = [
        "@zlib",
        "@zstd//:zstd",
        "@lz4//:lz4",
        "@lz4//:lz4_hc",
        "@lz4//:lz4_frame",
        "@snappy",
    ],
)
