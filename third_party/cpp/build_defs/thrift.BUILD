# Apache Thrift 0.16.0 - C++ library and compiler
# Built via CMake using rules_foreign_cc
#
# Strategy:
# - thrift_compiler: minimal build (compiler only, no SSL/libevent)
#   Used for code generation during build.
# - thrift_lib: full build with SSL/libevent for BE runtime linking (TODO)

load("@rules_foreign_cc//foreign_cc:defs.bzl", "cmake")

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
)

# Minimal build: only the thrift compiler binary for code generation.
# Does not build the C++ runtime library (no SSL/libevent needed).
cmake(
    name = "thrift_compiler_build",
    build_args = ["-j"],
    cache_entries = {
        "CMAKE_BUILD_TYPE": "Release",
        "BUILD_SHARED_LIBS": "OFF",
        "BUILD_TESTING": "OFF",
        "BUILD_COMPILER": "ON",
        "BUILD_CPP": "OFF",
        "BUILD_JAVA": "OFF",
        "BUILD_PYTHON": "OFF",
        "BUILD_JAVASCRIPT": "OFF",
        "BUILD_NODEJS": "OFF",
        "BUILD_TUTORIALS": "OFF",
        "WITH_LIBEVENT": "OFF",
        "WITH_OPENSSL": "OFF",
        "WITH_ZLIB": "OFF",
        # Suppress warnings on newer compilers
        "CMAKE_CXX_FLAGS": "-w",
        "CMAKE_C_FLAGS": "-w",
        # Use homebrew bison (3.8+) on macOS; system bison 2.3 is too old
        "BISON_EXECUTABLE": "/opt/homebrew/opt/bison/bin/bison",
    },
    lib_source = ":all_srcs",
    out_static_libs = [],
    out_binaries = ["thrift"],
    deps = [],
)

# Expose thrift compiler as a tool for code generation
filegroup(
    name = "thrift_compiler",
    srcs = [":thrift_compiler_build"],
    output_group = "thrift",
)

# Full thrift C++ runtime library (for BE linking)
# Built without SSL/libevent for now to avoid OpenSSL build issues on macOS.
# SSL support can be added later when needed.
cmake(
    name = "thrift_lib",
    build_args = ["-j"],
    cache_entries = {
        "CMAKE_BUILD_TYPE": "Release",
        "BUILD_SHARED_LIBS": "OFF",
        "BUILD_TESTING": "OFF",
        "BUILD_COMPILER": "OFF",
        "BUILD_CPP": "ON",
        "BUILD_JAVA": "OFF",
        "BUILD_PYTHON": "OFF",
        "BUILD_JAVASCRIPT": "OFF",
        "BUILD_NODEJS": "OFF",
        "BUILD_TUTORIALS": "OFF",
        "WITH_LIBEVENT": "OFF",
        "WITH_OPENSSL": "OFF",
        "WITH_ZLIB": "ON",
        "CMAKE_CXX_FLAGS": "-w",
        "CMAKE_C_FLAGS": "-w",
        "BISON_EXECUTABLE": "/opt/homebrew/opt/bison/bin/bison",
    },
    lib_source = ":all_srcs",
    out_static_libs = [
        "libthrift.a",
    ],
    deps = [
        "@zlib",
        "@boost.thread//:boost.thread",
        "@boost.locale//:boost.locale",
    ],
)
