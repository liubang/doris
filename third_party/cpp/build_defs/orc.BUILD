# Apache ORC 1.9.0 - Columnar storage format
# Hand-written cc_library (replaces rules_foreign_cc cmake)
#
# Strategy:
# 1. genrule generates orc-config.hh and Adaptor.hh (platform config headers)
# 2. genrule runs protoc on proto/orc_proto.proto
# 3. cc_library compiles all source files
#
# The orc-proto-wrapper.cc pattern: it #include's the generated orc_proto.pb.cc
# directly (with diagnostic suppression), so we need the generated .pb.cc/.pb.h
# accessible via include path during compilation.

load("@rules_cc//cc:defs.bzl", "cc_library")

package(default_visibility = ["//visibility:public"])

# =============================================================================
# Generated headers
# =============================================================================

# orc-config.hh (public, goes into c++/include/orc/)
genrule(
    name = "gen_orc_config_hh",
    outs = ["c++/include/orc/orc-config.hh"],
    cmd = """cat > $@ << 'EOF'
#ifndef ORC_CONFIG_HH
#define ORC_CONFIG_HH

#define ORC_VERSION "1.9.0"

#define ORC_CXX_HAS_CSTDINT

#ifdef ORC_CXX_HAS_CSTDINT
  #include <cstdint>
#else
  #include <stdint.h>
#endif

// Following MACROS should be keeped for backward compatibility.
#define ORC_NOEXCEPT noexcept
#define ORC_NULLPTR nullptr
#define ORC_OVERRIDE override
#define ORC_UNIQUE_PTR std::unique_ptr

#endif
EOF""",
)

# Adaptor.hh (private, used by c++/src/ sources)
# All features enabled on modern Linux/macOS 64-bit with GCC/Clang
genrule(
    name = "gen_adaptor_hh",
    outs = ["c++/src/Adaptor.hh"],
    cmd = """cat > $@ << 'EOF'
#ifndef ADAPTER_HH
#define ADAPTER_HH

#define HAS_PREAD
#define HAS_STRPTIME
#define HAS_DIAGNOSTIC_PUSH
#define HAS_DOUBLE_TO_STRING
#define HAS_INT64_TO_STRING
#define HAS_PRE_1970
#define HAS_POST_2038
#define HAS_STD_ISNAN
#define HAS_BUILTIN_OVERFLOW_CHECK
/* #undef NEEDS_Z_PREFIX */

#include "orc/orc-config.hh"
#include <string>

#ifdef HAS_DIAGNOSTIC_PUSH
  #ifdef __clang__
    #define DIAGNOSTIC_PUSH _Pragma("clang diagnostic push")
    #define DIAGNOSTIC_POP _Pragma("clang diagnostic pop")
  #elif defined(__GNUC__)
    #define DIAGNOSTIC_PUSH _Pragma("GCC diagnostic push")
    #define DIAGNOSTIC_POP _Pragma("GCC diagnostic pop")
  #elif defined(_MSC_VER)
    #define DIAGNOSTIC_PUSH __pragma(warning(push))
    #define DIAGNOSTIC_POP __pragma(warning(pop))
  #else
    #error("Unknown compiler")
  #endif
#else
  #define DIAGNOSTIC_PUSH
  #define DIAGNOSTIC_POP
#endif

#define PRAGMA(TXT) _Pragma(#TXT)

#ifdef __clang__
  #define DIAGNOSTIC_IGNORE(XXX) PRAGMA(clang diagnostic ignored XXX)
#elif defined(__GNUC__)
  #define DIAGNOSTIC_IGNORE(XXX) PRAGMA(GCC diagnostic ignored XXX)
#elif defined(_MSC_VER)
  #define DIAGNOSTIC_IGNORE(XXX) __pragma(warning(disable : XXX))
#else
  #define DIAGNOSTIC_IGNORE(XXX)
#endif

#ifndef UINT32_MAX
  #define UINT32_MAX 0xffffffff
#endif

#ifndef INT64_MAX
  #define INT64_MAX 0x7fffffffffffffff
#endif

#ifndef INT64_MIN
  #define INT64_MIN (-0x7fffffffffffffff - 1)
#endif

#define GTEST_LANG_CXX11 0

#ifndef HAS_STD_ISNAN
  #include <math.h>
  #define std::isnan(XXX) isnan(XXX)
#else
  #include <cmath>
#endif

#include <mutex>

#ifdef NEEDS_Z_PREFIX
#define Z_PREFIX 1
#endif

namespace orc {
  std::string to_string(double val);
  std::string to_string(int64_t val);
}

#ifdef HAS_BUILTIN_OVERFLOW_CHECK
  #define multiplyExact !__builtin_mul_overflow
  #define addExact !__builtin_add_overflow
#endif

#endif /* ADAPTER_HH */
EOF""",
)

# =============================================================================
# Protobuf code generation
# =============================================================================

# Generate orc_proto.pb.h and orc_proto.pb.cc from orc_proto.proto
genrule(
    name = "gen_orc_proto",
    srcs = ["proto/orc_proto.proto"],
    outs = [
        "c++/src/orc_proto.pb.h",
        "c++/src/orc_proto.pb.cc",
    ],
    cmd = "$(location @protobuf_21//:protoc) --cpp_out=$(RULEDIR)/c++/src --proto_path=$$(dirname $(location proto/orc_proto.proto)) $(location proto/orc_proto.proto)",
    tools = ["@protobuf_21//:protoc"],
)

# =============================================================================
# Public headers
# =============================================================================

cc_library(
    name = "orc_headers",
    hdrs = glob(["c++/include/orc/**/*.hh"]) + [":gen_orc_config_hh"],
    strip_include_prefix = "c++/include",
)

# =============================================================================
# ORC library
# =============================================================================

cc_library(
    name = "orc",
    srcs = [
        # Core sources
        "c++/src/Adaptor.cc",
        "c++/src/BlockBuffer.cc",
        "c++/src/BloomFilter.cc",
        "c++/src/BpackingDefault.cc",
        "c++/src/ByteRLE.cc",
        "c++/src/ColumnPrinter.cc",
        "c++/src/ColumnReader.cc",
        "c++/src/ColumnWriter.cc",
        "c++/src/Common.cc",
        "c++/src/Compression.cc",
        "c++/src/ConvertColumnReader.cc",
        "c++/src/CpuInfoUtil.cc",
        "c++/src/Exceptions.cc",
        "c++/src/Int128.cc",
        "c++/src/LzoDecompressor.cc",
        "c++/src/MemoryPool.cc",
        "c++/src/Murmur3.cc",
        "c++/src/OrcFile.cc",
        "c++/src/RLE.cc",
        "c++/src/RLEv1.cc",
        "c++/src/RLEV2Util.cc",
        "c++/src/RleDecoderV2.cc",
        "c++/src/RleEncoderV2.cc",
        "c++/src/Reader.cc",
        "c++/src/SchemaEvolution.cc",
        "c++/src/Statistics.cc",
        "c++/src/StripeStream.cc",
        "c++/src/Timezone.cc",
        "c++/src/TypeImpl.cc",
        "c++/src/Vector.cc",
        "c++/src/Writer.cc",
        # IO
        "c++/src/io/InputStream.cc",
        "c++/src/io/OutputStream.cc",
        # Search arguments
        "c++/src/sargs/ExpressionTree.cc",
        "c++/src/sargs/Literal.cc",
        "c++/src/sargs/PredicateLeaf.cc",
        "c++/src/sargs/SargsApplier.cc",
        "c++/src/sargs/SearchArgument.cc",
        "c++/src/sargs/TruthValue.cc",
        # Proto wrapper (includes generated orc_proto.pb.cc)
        "c++/src/wrap/orc-proto-wrapper.cc",
        # Internal headers (needed in srcs for sandbox access)
    ] + glob(["c++/src/**/*.hh", "c++/src/**/*.h"]) + [
        # Generated files
        ":gen_adaptor_hh",
    ],
    # orc_proto.pb.cc is #included by orc-proto-wrapper.cc as a textual header
    textual_hdrs = [":gen_orc_proto"],
    copts = [
        "-std=c++17",
        "-w",
        # Internal include path: c++/src/ (for #include "Reader.hh", "Adaptor.hh", etc.)
        "-iquote external/+cpp_deps+orc/c++/src",
        "-iquote $(BINDIR)/external/+cpp_deps+orc/c++/src",
        # Public include path (for #include "orc/orc-config.hh" from Adaptor.hh)
        "-Iexternal/+cpp_deps+orc/c++/include",
        "-I$(BINDIR)/external/+cpp_deps+orc/c++/include",
    ],
    local_defines = [
        "HAVE_SNAPPY",
        "HAVE_LZ4",
        "HAVE_ZSTD",
        "HAVE_ZLIB",
    ],
    deps = [
        ":orc_headers",
        "@protobuf_21//:protobuf",
        "@zlib",
        "@zstd//:zstd",
        "@lz4//:lz4",
        "@snappy//:snappy",
    ],
)
