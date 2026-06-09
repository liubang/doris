"""Module extension for C++ third-party dependencies not available in BCR.

These dependencies are built using rules_foreign_cc (cmake/configure_make)
or custom BUILD files provided in //third_party/cpp/build_defs/.
"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# =============================================================================
# Version Definitions (aligned with thirdparty/vars.sh)
# =============================================================================

_PROTOBUF_VERSION = "21.11"
_BRPC_VERSION = "1.4.0"
_THRIFT_VERSION = "0.16.0"
_ARROW_VERSION = "17.0.0"
_ORC_VERSION = "1.9.0"
_ROCKSDB_VERSION = "5.14.2"
_JEMALLOC_VERSION = "5.3.0"
_LIBUNWIND_VERSION = "1.6.2"
_GPERFTOOLS_VERSION = "2.10"
_LIBEVENT_VERSION = "2.1.12"
_LIBRDKAFKA_VERSION = "2.11.0"
_HYPERSCAN_VERSION = "5.4.2"
_VECTORSCAN_VERSION = "5.4.11"
_CROARING_VERSION = "2.1.2"
_S2GEOMETRY_VERSION = "0.10.0"
_OPENSSL_VERSION = "1.1.1s"
_LEVELDB_VERSION = "1.23"
_RAPIDJSON_COMMIT = "1a803826f1197b5e30703afe4b9c0e7dd48074f5"
_PARALLEL_HASHMAP_VERSION = "1.3.12"
_CCTZ_VERSION = "2.4"
_CONCURRENTQUEUE_VERSION = "1.0.4"
_XXHASH_VERSION = "0.8.3"
_SSE2NEON_VERSION = "1.6.0"
_FAST_FLOAT_VERSION = "3.9.0"
_FMT_VERSION = "7.1.3"
_AWS_SDK_VERSION = "1.11.219"
_BASE64_VERSION = "0.5.2"
_STREAMVBYTE_VERSION = "1.0.0"
_BITSHUFFLE_VERSION = "0.5.1"
_LIBDIVIDE_VERSION = "5.2.0"
_PUGIXML_VERSION = "1.15"

def _cpp_deps_impl(module_ctx):
    """Fetches all C++ third-party dependencies."""

    # =========================================================================
    # fmt 7.1.3 (formatting library - Doris requires 7.x, BCR only has 11.x)
    # =========================================================================
    http_archive(
        name = "fmt",
        urls = [
            "https://github.com/fmtlib/fmt/archive/refs/tags/{ver}.tar.gz".format(ver = _FMT_VERSION),
        ],
        strip_prefix = "fmt-{ver}".format(ver = _FMT_VERSION),
        build_file = "//third_party/cpp/build_defs:fmt.BUILD",
    )

    # =========================================================================
    # Protobuf 21.11 (C++ runtime for BE, required by brpc)
    # =========================================================================
    http_archive(
        name = "protobuf_21",
        urls = [
            "https://github.com/protocolbuffers/protobuf/archive/refs/tags/v{ver}.tar.gz".format(ver = _PROTOBUF_VERSION),
        ],
        strip_prefix = "protobuf-{ver}".format(ver = _PROTOBUF_VERSION),
        build_file = "//third_party/cpp/build_defs:protobuf.BUILD",
    )

    # =========================================================================
    # Apache brpc 1.4.0 (RPC framework)
    # =========================================================================
    http_archive(
        name = "brpc",
        urls = [
            "https://github.com/apache/brpc/archive/refs/tags/{ver}.tar.gz".format(ver = _BRPC_VERSION),
        ],
        strip_prefix = "brpc-{ver}".format(ver = _BRPC_VERSION),
        build_file = "//third_party/cpp/build_defs:brpc.BUILD",
        patches = [
            "//third_party/cpp/patches:brpc-1.4.0-write-background.patch",
        ],
        patch_args = ["-p1"],
    )

    # =========================================================================
    # Apache Thrift 0.16.0 (C++ library + compiler)
    # =========================================================================
    http_archive(
        name = "thrift_cpp",
        urls = [
            "https://archive.apache.org/dist/thrift/{ver}/thrift-{ver}.tar.gz".format(ver = _THRIFT_VERSION),
        ],
        strip_prefix = "thrift-{ver}".format(ver = _THRIFT_VERSION),
        build_file = "//third_party/cpp/build_defs:thrift.BUILD",
        patch_cmds = [
            # Generate thrift/config.h with platform-appropriate defines.
            # Both macOS and Linux have the standard POSIX headers; the only
            # difference is STRERROR_R_CHAR_P (glibc-specific) and
            # HAVE_GETHOSTBYNAME_R (not on macOS).
            """cat > lib/cpp/src/thrift/config.h << 'EOF'
#ifndef THRIFT_CONFIG_H
#define THRIFT_CONFIG_H

#define PACKAGE "thrift"
#define PACKAGE_VERSION "0.16.0"
#define PACKAGE_STRING "thrift 0.16.0"

#define ARITHMETIC_RIGHT_SHIFT 1
#define SIGNED_RIGHT_SHIFT_IS 1

/* POSIX headers available on both Linux and macOS */
#define HAVE_ARPA_INET_H 1
#define HAVE_FCNTL_H 1
#define HAVE_INTTYPES_H 1
#define HAVE_NETDB_H 1
#define HAVE_NETINET_IN_H 1
#define HAVE_SIGNAL_H 1
#define HAVE_STDINT_H 1
#define HAVE_UNISTD_H 1
#define HAVE_PTHREAD_H 1
#define HAVE_SYS_IOCTL_H 1
#define HAVE_SYS_PARAM_H 1
#define HAVE_SYS_RESOURCE_H 1
#define HAVE_SYS_SOCKET_H 1
#define HAVE_SYS_STAT_H 1
#define HAVE_SYS_UN_H 1
#define HAVE_POLL_H 1
#define HAVE_SYS_POLL_H 1
#define HAVE_SYS_SELECT_H 1
#define HAVE_SYS_TIME_H 1
#define HAVE_SCHED_H 1
#define HAVE_STRINGS_H 1

/* Functions */
#define HAVE_GETHOSTBYNAME 1
#define HAVE_STRERROR_R 1
#define HAVE_SCHED_GET_PRIORITY_MAX 1
#define HAVE_SCHED_GET_PRIORITY_MIN 1

/* Platform-specific */
#ifdef __linux__
#define HAVE_GETHOSTBYNAME_R 1
#define STRERROR_R_CHAR_P 1
#endif

#endif /* THRIFT_CONFIG_H */
EOF""",
        ],
    )

    # =========================================================================
    # Apache Arrow 17.0.0 (columnar in-memory format)
    # =========================================================================
    http_archive(
        name = "arrow",
        urls = [
            "https://github.com/apache/arrow/archive/refs/tags/apache-arrow-{ver}.tar.gz".format(ver = _ARROW_VERSION),
        ],
        strip_prefix = "arrow-apache-arrow-{ver}".format(ver = _ARROW_VERSION),
        build_file = "//third_party/cpp/build_defs:arrow.BUILD",
        patches = [
            "//third_party/cpp/patches:arrow-fix-macos-libtool-detection.patch",
            "//third_party/cpp/patches:arrow-skip-empty-ranlib.patch",
            "//third_party/cpp/patches:arrow-fix-config-h-compiler-flags.patch",
        ],
        patch_args = ["-p1"],
    )

    # =========================================================================
    # Apache ORC 1.9.0 (columnar storage format)
    # =========================================================================
    http_archive(
        name = "orc",
        urls = [
            "https://github.com/apache/orc/archive/refs/tags/v{ver}.tar.gz".format(ver = _ORC_VERSION),
        ],
        strip_prefix = "orc-{ver}".format(ver = _ORC_VERSION),
        build_file = "//third_party/cpp/build_defs:orc.BUILD",
        patches = [
            "//third_party/cpp/patches:orc-doris-common.patch",
            "//third_party/cpp/patches:orc-doris-reader.patch",
            "//third_party/cpp/patches:orc-doris-orcfile.patch",
        ],
        patch_args = ["-p1"],
    )

    # =========================================================================
    # RocksDB 5.14.2 (embedded key-value store)
    # =========================================================================
    http_archive(
        name = "rocksdb",
        urls = [
            "https://github.com/facebook/rocksdb/archive/refs/tags/v{ver}.tar.gz".format(ver = _ROCKSDB_VERSION),
        ],
        strip_prefix = "rocksdb-{ver}".format(ver = _ROCKSDB_VERSION),
        build_file = "//third_party/cpp/build_defs:rocksdb.BUILD",
        patches = ["//third_party/cpp/patches:rocksdb-metadata-incomplete-type.patch"],
        patch_args = ["-p1"],
        # Fixes for newer Clang/libc++ compatibility:
        # 1. autovector<const T*> incompatible with newer libc++ std::sort
        # 2. cassandra/format.h depends on gtest via testharness.h (FRIEND_TEST macro)
        # 3. cassandra/format.cc uses shared_ptr without std:: prefix
        patch_cmds = [
            "sed -i.bak 's/autovector<const IngestedFileInfo\\*> sorted_files;/std::vector<const IngestedFileInfo*> sorted_files;/' db/external_sst_file_ingestion_job.cc && rm -f db/external_sst_file_ingestion_job.cc.bak",
            "perl -pi -e 's|#include \"util/testharness.h\"|#ifndef FRIEND_TEST\\n#define FRIEND_TEST(a, b)\\n#endif|' utilities/cassandra/format.h",
            "sed -i.bak 's/        shared_ptr<Tombstone>/        std::shared_ptr<Tombstone>/' utilities/cassandra/format.cc && rm -f utilities/cassandra/format.cc.bak",
            # Move conflicting headers (util/coding.h, util/random.h, util/string_util.h)
            # to _private/ subdirectory to prevent -iquote shadowing of Doris headers.
            # Bazel always adds -iquote <package_root> for external deps, which causes
            # RocksDB's util/coding.h to shadow Doris's be/src/util/coding.h.
            # By moving them to _private/util/, the -iquote search won't find them,
            # while RocksDB internal compilation uses -I<pkg>/_private in copts.
            "mkdir -p _private/util && cp util/coding.h _private/util/coding.h && cp util/random.h _private/util/random.h && cp util/string_util.h _private/util/string_util.h && rm util/coding.h util/random.h util/string_util.h",
        ],
    )

    # =========================================================================
    # jemalloc 5.3.0 (memory allocator)
    # =========================================================================
    http_archive(
        name = "jemalloc",
        urls = [
            "https://github.com/jemalloc/jemalloc/releases/download/{ver}/jemalloc-{ver}.tar.bz2".format(ver = _JEMALLOC_VERSION),
        ],
        strip_prefix = "jemalloc-{ver}".format(ver = _JEMALLOC_VERSION),
        build_file = "//third_party/cpp/build_defs:jemalloc.BUILD",
    )

    # =========================================================================
    # libunwind 1.6.2 (stack unwinding)
    # =========================================================================
    http_archive(
        name = "libunwind",
        urls = [
            "https://github.com/libunwind/libunwind/releases/download/v{ver}/libunwind-{ver}.tar.gz".format(ver = _LIBUNWIND_VERSION),
        ],
        strip_prefix = "libunwind-{ver}".format(ver = _LIBUNWIND_VERSION),
        build_file = "//third_party/cpp/build_defs:libunwind.BUILD",
    )

    # =========================================================================
    # gperftools 2.10 (tcmalloc, profiling tools)
    # =========================================================================
    http_archive(
        name = "gperftools",
        urls = [
            "https://github.com/gperftools/gperftools/releases/download/gperftools-{ver}/gperftools-{ver}.tar.gz".format(ver = _GPERFTOOLS_VERSION),
        ],
        strip_prefix = "gperftools-{ver}".format(ver = _GPERFTOOLS_VERSION),
        build_file = "//third_party/cpp/build_defs:gperftools.BUILD",
    )

    # =========================================================================
    # libevent 2.1.12 (event notification library)
    # =========================================================================
    http_archive(
        name = "libevent",
        urls = [
            "https://github.com/libevent/libevent/releases/download/release-{ver}-stable/libevent-{ver}-stable.tar.gz".format(ver = _LIBEVENT_VERSION),
        ],
        strip_prefix = "libevent-{ver}-stable".format(ver = _LIBEVENT_VERSION),
        build_file = "//third_party/cpp/build_defs:libevent.BUILD",
    )

    # =========================================================================
    # librdkafka 2.11.0 (Apache Kafka C/C++ client)
    # =========================================================================
    http_archive(
        name = "librdkafka",
        urls = [
            "https://github.com/confluentinc/librdkafka/archive/refs/tags/v{ver}.tar.gz".format(ver = _LIBRDKAFKA_VERSION),
        ],
        strip_prefix = "librdkafka-{ver}".format(ver = _LIBRDKAFKA_VERSION),
        build_file = "//third_party/cpp/build_defs:librdkafka.BUILD",
    )

    # =========================================================================
    # Hyperscan 5.4.2 / Vectorscan 5.4.11 (regex engine)
    # On x86_64: use Intel Hyperscan; on ARM: use Vectorscan
    # =========================================================================
    http_archive(
        name = "hyperscan",
        urls = [
            "https://github.com/intel/hyperscan/archive/refs/tags/v{ver}.tar.gz".format(ver = _HYPERSCAN_VERSION),
        ],
        strip_prefix = "hyperscan-{ver}".format(ver = _HYPERSCAN_VERSION),
        build_file = "//third_party/cpp/build_defs:hyperscan.BUILD",
    )

    http_archive(
        name = "vectorscan",
        urls = [
            "https://github.com/VectorCamp/vectorscan/archive/refs/tags/vectorscan/{ver}.tar.gz".format(ver = _VECTORSCAN_VERSION),
        ],
        strip_prefix = "vectorscan-vectorscan-{ver}".format(ver = _VECTORSCAN_VERSION),
        build_file = "//third_party/cpp/build_defs:vectorscan.BUILD",
        patches = [
            "//third_party/cpp/patches:vectorscan-disable-tools.patch",
        ],
        patch_args = ["-p1"],
    )

    # =========================================================================
    # CRoaring 2.1.2 (Roaring Bitmaps)
    # =========================================================================
    http_archive(
        name = "croaring",
        urls = [
            "https://github.com/RoaringBitmap/CRoaring/archive/refs/tags/v{ver}.tar.gz".format(ver = _CROARING_VERSION),
        ],
        strip_prefix = "CRoaring-{ver}".format(ver = _CROARING_VERSION),
        build_file = "//third_party/cpp/build_defs:croaring.BUILD",
    )

    # =========================================================================
    # S2 Geometry 0.10.0 (spherical geometry library)
    # =========================================================================
    http_archive(
        name = "s2geometry",
        urls = [
            "https://github.com/google/s2geometry/archive/refs/tags/v{ver}.tar.gz".format(ver = _S2GEOMETRY_VERSION),
        ],
        strip_prefix = "s2geometry-{ver}".format(ver = _S2GEOMETRY_VERSION),
        build_file = "//third_party/cpp/build_defs:s2geometry.BUILD",
    )

    # =========================================================================
    # CLucene (full-text search, Doris fork in contrib/)
    # NOTE: CLucene is built from be/contrib/clucene, not fetched externally
    # =========================================================================
    http_archive(
        name = "clucene",
        urls = [
            "https://github.com/apache/doris-thirdparty/archive/refs/heads/clucene.tar.gz",
        ],
        strip_prefix = "doris-thirdparty-clucene",
        build_file = "//third_party/cpp/build_defs:clucene.BUILD",
        patches = [
            "//third_party/cpp/patches:clucene-install-internal-headers.patch",
            "//third_party/cpp/patches:clucene-install-shared-headers.patch",
        ],
        patch_args = ["-p1"],
    )

    # =========================================================================
    # AWS SDK C++ 1.11.219 (S3, transfer, identity-management, sts)
    # =========================================================================
    http_archive(
        name = "aws_sdk",
        urls = [
            "https://github.com/aws/aws-sdk-cpp/archive/refs/tags/{ver}.tar.gz".format(ver = _AWS_SDK_VERSION),
        ],
        strip_prefix = "aws-sdk-cpp-{ver}".format(ver = _AWS_SDK_VERSION),
        build_file = "//third_party/cpp/build_defs:aws_sdk.BUILD",
    )

    # =========================================================================
    # OpenSSL 1.1.1s (TLS/crypto library for BE runtime)
    # =========================================================================
    http_archive(
        name = "openssl",
        urls = [
            "https://github.com/openssl/openssl/releases/download/OpenSSL_1_1_1s/openssl-{ver}.tar.gz".format(ver = _OPENSSL_VERSION),
        ],
        strip_prefix = "openssl-{ver}".format(ver = _OPENSSL_VERSION),
        build_file = "//third_party/cpp/build_defs:openssl.BUILD",
    )

    # =========================================================================
    # LevelDB 1.23 (embedded key-value store)
    # =========================================================================
    http_archive(
        name = "leveldb",
        urls = [
            "https://github.com/google/leveldb/archive/refs/tags/{ver}.tar.gz".format(ver = _LEVELDB_VERSION),
        ],
        strip_prefix = "leveldb-{ver}".format(ver = _LEVELDB_VERSION),
        build_file = "//third_party/cpp/build_defs:leveldb.BUILD",
        # 把源文件移到 _src/ 子目录，避免 leveldb 的 util/histogram.h、
        # util/coding.h 等内部头文件通过 Bazel 的 -iquote 泄漏到下游，
        # 与 Doris 的同名头文件冲突。
        patch_cmds = [
            "mkdir -p _src",
            "mv db helpers port table util _src/",
        ],
    )

    # =========================================================================
    # RapidJSON (fast JSON parser)
    # =========================================================================
    http_archive(
        name = "rapidjson",
        urls = [
            "https://github.com/Tencent/rapidjson/archive/{commit}.tar.gz".format(commit = _RAPIDJSON_COMMIT),
        ],
        strip_prefix = "rapidjson-{commit}".format(commit = _RAPIDJSON_COMMIT),
        build_file = "//third_party/cpp/build_defs:rapidjson.BUILD",
    )

    # =========================================================================
    # parallel-hashmap 1.3.12 (header-only fast hash maps/sets)
    # =========================================================================
    http_archive(
        name = "parallel_hashmap",
        urls = [
            "https://github.com/greg7mdp/parallel-hashmap/archive/refs/tags/v{ver}.tar.gz".format(ver = _PARALLEL_HASHMAP_VERSION),
        ],
        strip_prefix = "parallel-hashmap-{ver}".format(ver = _PARALLEL_HASHMAP_VERSION),
        build_file = "//third_party/cpp/build_defs:parallel_hashmap.BUILD",
    )

    # =========================================================================
    # cctz 2.4 (time zone and civil-time library)
    # =========================================================================
    http_archive(
        name = "cctz",
        urls = [
            "https://github.com/google/cctz/archive/refs/tags/v{ver}.tar.gz".format(ver = _CCTZ_VERSION),
        ],
        strip_prefix = "cctz-{ver}".format(ver = _CCTZ_VERSION),
        build_file = "//third_party/cpp/build_defs:cctz.BUILD",
        patches = [
            "//third_party/cpp/patches:cctz-lookup-offset.patch",
            "//third_party/cpp/patches:cctz-civil-cache.patch",
        ],
        patch_args = ["-p1"],
    )

    # =========================================================================
    # pdqsort (pattern-defeating quicksort, header-only)
    # =========================================================================
    http_archive(
        name = "pdqsort",
        urls = [
            "https://github.com/orlp/pdqsort/archive/refs/heads/master.tar.gz",
        ],
        strip_prefix = "pdqsort-master",
        build_file = "//third_party/cpp/build_defs:pdqsort.BUILD",
    )

    # =========================================================================
    # concurrentqueue 1.0.4 (lock-free MPMC queue, header-only)
    # =========================================================================
    http_archive(
        name = "concurrentqueue",
        urls = [
            "https://github.com/cameron314/concurrentqueue/archive/refs/tags/v{ver}.tar.gz".format(ver = _CONCURRENTQUEUE_VERSION),
        ],
        strip_prefix = "concurrentqueue-{ver}".format(ver = _CONCURRENTQUEUE_VERSION),
        build_file = "//third_party/cpp/build_defs:concurrentqueue.BUILD",
    )

    # =========================================================================
    # xxHash 0.8.3 (extremely fast hash algorithm)
    # =========================================================================
    http_archive(
        name = "xxhash",
        urls = [
            "https://github.com/Cyan4973/xxHash/archive/refs/tags/v{ver}.tar.gz".format(ver = _XXHASH_VERSION),
        ],
        strip_prefix = "xxHash-{ver}".format(ver = _XXHASH_VERSION),
        build_file = "//third_party/cpp/build_defs:xxhash.BUILD",
    )

    # =========================================================================
    # sse2neon 1.6.0 (SSE intrinsics to NEON translation, header-only)
    # =========================================================================
    http_archive(
        name = "sse2neon",
        urls = [
            "https://github.com/DLTcollab/sse2neon/archive/refs/tags/v{ver}.tar.gz".format(ver = _SSE2NEON_VERSION),
        ],
        strip_prefix = "sse2neon-{ver}".format(ver = _SSE2NEON_VERSION),
        build_file = "//third_party/cpp/build_defs:sse2neon.BUILD",
    )

    # =========================================================================
    # fast_float 3.9.0 (fast float parsing, header-only)
    # =========================================================================
    http_archive(
        name = "fast_float",
        urls = [
            "https://github.com/fastfloat/fast_float/archive/refs/tags/v{ver}.tar.gz".format(ver = _FAST_FLOAT_VERSION),
        ],
        strip_prefix = "fast_float-{ver}".format(ver = _FAST_FLOAT_VERSION),
        build_file = "//third_party/cpp/build_defs:fast_float.BUILD",
    )

    # =========================================================================
    # cpp-TimSort 2.1.0 (gfx::timsort - stable sorting algorithm)
    # =========================================================================
    http_archive(
        name = "cpp_timsort",
        urls = [
            "https://github.com/timsort/cpp-TimSort/archive/refs/tags/v2.1.0.tar.gz",
        ],
        strip_prefix = "cpp-TimSort-2.1.0",
        build_file = "//third_party/cpp/build_defs:cpp_timsort.BUILD",
    )

    # =========================================================================
    # streamvbyte 1.0.0 (fast integer compression)
    # =========================================================================
    http_archive(
        name = "streamvbyte",
        urls = [
            "https://github.com/lemire/streamvbyte/archive/refs/tags/v{ver}.tar.gz".format(ver = _STREAMVBYTE_VERSION),
        ],
        strip_prefix = "streamvbyte-{ver}".format(ver = _STREAMVBYTE_VERSION),
        build_file = "//third_party/cpp/build_defs:streamvbyte.BUILD",
    )

    # =========================================================================
    # aklomp/base64 0.5.2 (fast base64 encoding/decoding with SIMD)
    # =========================================================================
    http_archive(
        name = "libbase64",
        urls = [
            "https://github.com/aklomp/base64/archive/refs/tags/v{ver}.tar.gz".format(ver = _BASE64_VERSION),
        ],
        strip_prefix = "base64-{ver}".format(ver = _BASE64_VERSION),
        build_file = "//third_party/cpp/build_defs:libbase64.BUILD",
        patches = ["//third_party/cpp/patches:base64-rename-functions.patch"],
        patch_args = ["-p1"],
    )

    # =========================================================================
    # bitshuffle 0.5.1 (byte/bit transposition for compression)
    # =========================================================================
    http_archive(
        name = "bitshuffle",
        urls = [
            "https://github.com/kiyo-masui/bitshuffle/archive/refs/tags/{ver}.tar.gz".format(ver = _BITSHUFFLE_VERSION),
        ],
        strip_prefix = "bitshuffle-{ver}".format(ver = _BITSHUFFLE_VERSION),
        build_file = "//third_party/cpp/build_defs:bitshuffle.BUILD",
        patches = ["//third_party/cpp/patches:bitshuffle-0.5.1.patch"],
        patch_args = ["-p1"],
    )

    # =========================================================================
    # libdivide 5.2.0 (fast integer division, header-only)
    # =========================================================================
    http_archive(
        name = "libdivide",
        urls = [
            "https://github.com/ridiculousfish/libdivide/archive/refs/tags/v{ver}.tar.gz".format(ver = _LIBDIVIDE_VERSION),
        ],
        strip_prefix = "libdivide-{ver}".format(ver = _LIBDIVIDE_VERSION),
        build_file = "//third_party/cpp/build_defs:libdivide.BUILD",
    )

    # =========================================================================
    # lz4_compat (wrapper providing lz4/ prefixed include paths for Doris)
    # Doris uses #include <lz4/lz4.h> but BCR @lz4 provides <lz4.h>
    # =========================================================================
    http_archive(
        name = "lz4_compat",
        urls = [
            "https://github.com/lz4/lz4/releases/download/v1.9.4/lz4-1.9.4.tar.gz",
        ],
        strip_prefix = "lz4-1.9.4",
        build_file = "//third_party/cpp/build_defs:lz4_compat.BUILD",
    )

    # =========================================================================
    # pugixml 1.15 (lightweight C++ XML processing library)
    # =========================================================================
    http_archive(
        name = "pugixml",
        urls = [
            "https://github.com/zeux/pugixml/releases/download/v{ver}/pugixml-{ver}.tar.gz".format(ver = _PUGIXML_VERSION),
        ],
        strip_prefix = "pugixml-{ver}".format(ver = _PUGIXML_VERSION),
        build_file = "//third_party/cpp/build_defs:pugixml.BUILD",
    )

    return module_ctx.extension_metadata(
        root_module_direct_deps = "all",
        root_module_direct_dev_deps = [],
    )

cpp_deps = module_extension(
    implementation = _cpp_deps_impl,
)
