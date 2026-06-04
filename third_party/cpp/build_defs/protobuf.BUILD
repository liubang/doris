# Protobuf 21.11 (3.21.11) - C++ runtime for Doris BE
# Built via CMake using rules_foreign_cc
# This is separate from the global protobuf (29.x) used by rules_proto for FE.
#
# NOTE: protobuf 21.x does NOT depend on abseil-cpp.
# Abseil dependency was introduced in protobuf 22.x+.

load("@rules_foreign_cc//foreign_cc:defs.bzl", "cmake")

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
)

cmake(
    name = "protobuf",
    build_args = ["-j"],
    cache_entries = {
        "CMAKE_BUILD_TYPE": "Release",
        "protobuf_BUILD_TESTS": "OFF",
        "protobuf_BUILD_SHARED_LIBS": "OFF",
        "protobuf_WITH_ZLIB": "ON",
        "protobuf_BUILD_PROTOC_BINARIES": "ON",
        # Suppress warnings that may fail compilation on newer compilers
        "CMAKE_CXX_FLAGS": "-w",
        "CMAKE_C_FLAGS": "-w",
    },
    lib_source = ":all_srcs",
    out_static_libs = [
        "libprotobuf.a",
        "libprotobuf-lite.a",
        "libprotoc.a",
    ],
    out_binaries = ["protoc"],
    deps = [
        "@zlib",
    ],
)

# Expose protoc as a tool
filegroup(
    name = "protoc",
    srcs = [":protobuf"],
    output_group = "protoc",
)
