# Apache Arrow 17.0.0 - Columnar in-memory format
# Built via CMake using rules_foreign_cc
#
# Strategy: Use BUNDLED for most deps that have CMake find_package issues
# with Bazel-native libraries (re2, lz4, rapidjson, thrift, xsimd).
# Use SYSTEM only for deps that rules_foreign_cc can correctly expose
# (zlib, snappy, brotli, zstd - these have simple include/lib layouts).
#
# Arrow Flight is disabled for now due to complex gRPC/gflags/protobuf
# dependency chain. Will be re-enabled once those deps are properly wired.

load("@rules_foreign_cc//foreign_cc:defs.bzl", "cmake")

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
)

cmake(
    name = "arrow",
    build_args = ["-j"],
    cache_entries = {
        "CMAKE_BUILD_TYPE": "Release",
        # Build configuration
        "ARROW_BUILD_SHARED": "OFF",
        "ARROW_BUILD_STATIC": "ON",
        "ARROW_BUILD_TESTS": "OFF",
        "ARROW_BUILD_BENCHMARKS": "OFF",
        "ARROW_BUILD_INTEGRATION": "OFF",
        # Feature flags
        "ARROW_COMPUTE": "ON",
        "ARROW_CSV": "ON",
        "ARROW_FILESYSTEM": "ON",
        "ARROW_DATASET": "ON",
        "ARROW_ACERO": "ON",
        "ARROW_HDFS": "ON",
        "ARROW_IPC": "ON",
        "ARROW_JSON": "ON",
        "ARROW_ORC": "OFF",
        "ARROW_PARQUET": "ON",
        # Disabled features (complex dep chains)
        "ARROW_FLIGHT": "OFF",
        "ARROW_FLIGHT_SQL": "OFF",
        "ARROW_WITH_GRPC": "OFF",
        "ARROW_USE_GLOG": "OFF",
        # Disable jemalloc - Doris uses its own jemalloc
        "ARROW_JEMALLOC": "OFF",
        # Compression
        "ARROW_WITH_BROTLI": "ON",
        "ARROW_WITH_LZ4": "ON",
        "ARROW_WITH_SNAPPY": "ON",
        "ARROW_WITH_ZLIB": "ON",
        "ARROW_WITH_ZSTD": "ON",
        # Other deps
        "ARROW_WITH_RE2": "ON",
        "ARROW_WITH_UTF8PROC": "OFF",
        "ARROW_GFLAGS_USE_SHARED": "OFF",
        "PARQUET_BUILD_EXECUTABLES": "OFF",
        # Dependency sourcing: BUNDLED for deps with CMake find issues
        "ARROW_DEPENDENCY_SOURCE": "AUTO",
        "BOOST_ROOT": "$$EXT_BUILD_DEPS",
        "Thrift_SOURCE": "BUNDLED",
        "xsimd_SOURCE": "BUNDLED",
        "RapidJSON_SOURCE": "BUNDLED",
        "re2_SOURCE": "BUNDLED",
        "lz4_SOURCE": "BUNDLED",
        "Brotli_SOURCE": "BUNDLED",
        "Snappy_SOURCE": "BUNDLED",
    },
    tags = ["requires-network"],
    # Arrow's CMakeLists.txt is in cpp/ subdirectory
    working_directory = "cpp",
    lib_source = ":all_srcs",
    out_static_libs = [
        "libarrow.a",
        "libparquet.a",
        "libarrow_dataset.a",
        "libarrow_acero.a",
    ],
    deps = [
        "@zlib",
        "@zstd//:zstd",
        "@boost.algorithm//:boost.algorithm",
        "@boost.filesystem//:boost.filesystem",
        "@boost.locale//:boost.locale",
        "@boost.numeric_conversion//:boost.numeric_conversion",
        "@boost.system//:boost.system",
        "@boost.regex//:boost.regex",
        "@boost.tokenizer//:boost.tokenizer",
    ],
)
