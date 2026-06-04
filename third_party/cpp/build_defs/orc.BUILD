# Apache ORC 1.9.0 - Columnar storage format
# Built via CMake using rules_foreign_cc

load("@rules_foreign_cc//foreign_cc:defs.bzl", "cmake")

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
)

cmake(
    name = "orc",
    build_args = ["-j"],
    cache_entries = {
        "CMAKE_BUILD_TYPE": "Release",
        "BUILD_SHARED_LIBS": "OFF",
        "BUILD_JAVA": "OFF",
        "BUILD_TOOLS": "OFF",
        "BUILD_CPP_TESTS": "OFF",
        "BUILD_LIBHDFSPP": "OFF",
        "INSTALL_VENDORED_LIBS": "OFF",
        "BUILD_POSITION_INDEPENDENT_LIB": "ON",
        "STOP_BUILD_ON_WARNING": "OFF",
    },
    env = {
        "SNAPPY_HOME": "$$EXT_BUILD_DEPS",
        "ZLIB_HOME": "$$EXT_BUILD_DEPS",
        "LZ4_HOME": "$$EXT_BUILD_DEPS",
        "ZSTD_HOME": "$$EXT_BUILD_DEPS",
        "PROTOBUF_HOME": "$$EXT_BUILD_DEPS/protobuf",
    },
    lib_source = ":all_srcs",
    out_static_libs = ["liborc.a"],
    deps = [
        "@protobuf_21//:protobuf",
        "@zlib",
        "@zstd//:zstd",
        "@lz4//:lz4",
        "@snappy//:snappy",
    ],
)
