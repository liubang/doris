# Apache Thrift 0.16.0 - C++ library and compiler
# thrift_lib: handwritten cc_library for BE runtime linking
# thrift_compiler: cmake build for the thrift code generation tool
#
# Strategy:
# - thrift_lib uses cc_library with explicit source lists
# - thrift_compiler still uses cmake (complex flex/bison tool)
# - config.h is generated via patch_cmds in extensions.bzl

load("@rules_cc//cc:defs.bzl", "cc_library")
load("@rules_foreign_cc//foreign_cc:defs.bzl", "cmake")

package(default_visibility = ["//visibility:public"])

# =============================================================================
# Thrift C++ Runtime Library (cc_library)
# =============================================================================

# Public headers: exposed with strip_include_prefix so users can do:
#   #include <thrift/Thrift.h>
#   #include <thrift/protocol/TBinaryProtocol.h>
cc_library(
    name = "thrift_headers",
    hdrs = glob([
        "lib/cpp/src/thrift/**/*.h",
        "lib/cpp/src/thrift/**/*.tcc",
    ]),
    strip_include_prefix = "lib/cpp/src",
)

# Full thrift C++ runtime library (for BE linking)
# Built without SSL/libevent, with zlib transport support.
cc_library(
    name = "thrift_lib",
    srcs = [
        # Core sources
        "lib/cpp/src/thrift/TApplicationException.cpp",
        "lib/cpp/src/thrift/TOutput.cpp",
        "lib/cpp/src/thrift/VirtualProfiling.cpp",
        "lib/cpp/src/thrift/async/TAsyncChannel.cpp",
        "lib/cpp/src/thrift/async/TAsyncProtocolProcessor.cpp",
        "lib/cpp/src/thrift/async/TConcurrentClientSyncInfo.cpp",
        # Concurrency
        "lib/cpp/src/thrift/concurrency/Monitor.cpp",
        "lib/cpp/src/thrift/concurrency/Mutex.cpp",
        "lib/cpp/src/thrift/concurrency/Thread.cpp",
        "lib/cpp/src/thrift/concurrency/ThreadFactory.cpp",
        "lib/cpp/src/thrift/concurrency/ThreadManager.cpp",
        "lib/cpp/src/thrift/concurrency/TimerManager.cpp",
        # Processor
        "lib/cpp/src/thrift/processor/PeekProcessor.cpp",
        # Protocol
        "lib/cpp/src/thrift/protocol/TBase64Utils.cpp",
        "lib/cpp/src/thrift/protocol/TDebugProtocol.cpp",
        "lib/cpp/src/thrift/protocol/THeaderProtocol.cpp",
        "lib/cpp/src/thrift/protocol/TJSONProtocol.cpp",
        "lib/cpp/src/thrift/protocol/TMultiplexedProtocol.cpp",
        "lib/cpp/src/thrift/protocol/TProtocol.cpp",
        # Server
        "lib/cpp/src/thrift/server/TConnectedClient.cpp",
        "lib/cpp/src/thrift/server/TNonblockingServer.cpp",
        "lib/cpp/src/thrift/server/TServer.cpp",
        "lib/cpp/src/thrift/server/TServerFramework.cpp",
        "lib/cpp/src/thrift/server/TSimpleServer.cpp",
        "lib/cpp/src/thrift/server/TThreadPoolServer.cpp",
        "lib/cpp/src/thrift/server/TThreadedServer.cpp",
        # Transport
        "lib/cpp/src/thrift/transport/SocketCommon.cpp",
        "lib/cpp/src/thrift/transport/TBufferTransports.cpp",
        "lib/cpp/src/thrift/transport/TFDTransport.cpp",
        "lib/cpp/src/thrift/transport/TFileTransport.cpp",
        "lib/cpp/src/thrift/transport/THeaderTransport.cpp",
        "lib/cpp/src/thrift/transport/THttpClient.cpp",
        "lib/cpp/src/thrift/transport/THttpServer.cpp",
        "lib/cpp/src/thrift/transport/THttpTransport.cpp",
        "lib/cpp/src/thrift/transport/TNonblockingServerSocket.cpp",
        "lib/cpp/src/thrift/transport/TPipe.cpp",
        "lib/cpp/src/thrift/transport/TPipeServer.cpp",
        "lib/cpp/src/thrift/transport/TServerSocket.cpp",
        "lib/cpp/src/thrift/transport/TSimpleFileTransport.cpp",
        "lib/cpp/src/thrift/transport/TSocket.cpp",
        "lib/cpp/src/thrift/transport/TSocketPool.cpp",
        "lib/cpp/src/thrift/transport/TTransportException.cpp",
        "lib/cpp/src/thrift/transport/TTransportUtils.cpp",
        "lib/cpp/src/thrift/transport/TZlibTransport.cpp",
    ],
    copts = [
        "-w",
        "-Iexternal/+cpp_deps+thrift_cpp/lib/cpp/src",
    ],
    local_defines = [
        "THRIFT_STATIC_DEFINE",
        "__STDC_FORMAT_MACROS",
        "__STDC_LIMIT_MACROS",
    ],
    deps = [
        ":thrift_headers",
        "@libevent",
        "@zlib",
        "@boost.thread//:boost.thread",
        "@boost.locale//:boost.locale",
    ],
    linkopts = ["-lpthread"],
)

# =============================================================================
# Thrift Compiler (built via cmake for code generation)
# =============================================================================

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
