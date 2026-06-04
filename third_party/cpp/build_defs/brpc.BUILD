# Apache brpc 1.4.0 - RPC framework
# Built via CMake using rules_foreign_cc
#
# NOTE: WITH_GLOG is OFF because glog's Bazel defines contain
# __attribute__((deprecated)) which has unescaped parentheses that break
# rules_foreign_cc's shell script generation. brpc will use its own logging.
# Doris BE links glog separately and can still use glog-based logging.

load("@rules_foreign_cc//foreign_cc:defs.bzl", "cmake")

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
)

cmake(
    name = "brpc",
    build_args = ["-j"],
    cache_entries = {
        "CMAKE_BUILD_TYPE": "Release",
        "BUILD_SHARED_LIBS": "OFF",
        "BUILD_BRPC_TOOLS": "OFF",
        "WITH_GLOG": "OFF",
        "WITH_THRIFT": "OFF",
        "DOWNLOAD_GTEST": "OFF",
        "WITH_DEBUG_SYMBOLS": "OFF",
    },
    lib_source = ":all_srcs",
    out_static_libs = ["libbrpc.a"],
    deps = [
        "@protobuf_21//:protobuf",
        "@gflags//:gflags",
        "@openssl//:openssl",
        "@libevent//:libevent",
        "@leveldb//:leveldb",
        "@zlib",
    ],
)
