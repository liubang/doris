# librdkafka 2.11.0 - Apache Kafka C/C++ client
# Built via CMake using rules_foreign_cc

load("@rules_foreign_cc//foreign_cc:defs.bzl", "cmake")

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
)

cmake(
    name = "librdkafka",
    build_args = ["-j"],
    cache_entries = {
        "CMAKE_BUILD_TYPE": "Release",
        "RDKAFKA_BUILD_STATIC": "ON",
        "RDKAFKA_BUILD_EXAMPLES": "OFF",
        "RDKAFKA_BUILD_TESTS": "OFF",
        "WITH_SSL": "ON",
        "WITH_SASL": "ON",
        "WITH_ZLIB": "ON",
        "WITH_ZSTD": "ON",
        "WITH_LZ4_EXT": "ON",
        "ENABLE_LZ4_EXT": "ON",
    },
    lib_source = ":all_srcs",
    out_static_libs = [
        "librdkafka.a",
        "librdkafka++.a",
    ],
    deps = [
        "@openssl//:openssl",
        "@zlib",
        "@zstd//:zstd",
        "@lz4//:lz4",
    ],
)
