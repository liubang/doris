# librdkafka 2.11.0 - Apache Kafka C/C++ client library
# Hand-written cc_library BUILD file replacing rules_foreign_cc cmake build

package(default_visibility = ["//visibility:public"])

# Generate config.h with platform-appropriate defines
genrule(
    name = "generate_config_h",
    outs = ["config.h"],
    cmd = select({
        "@platforms//os:macos": """
cat > $@ << 'EOF'
#define WITHOUT_OPTIMIZATION 0
#define ENABLE_DEVEL 0
#define ENABLE_REFCNT_DEBUG 0

#define HAVE_ATOMICS_32 1
#define HAVE_ATOMICS_32_SYNC 0

#if (HAVE_ATOMICS_32)
# if (HAVE_ATOMICS_32_SYNC)
#  define ATOMIC_OP32(OP1,OP2,PTR,VAL) __sync_ ## OP1 ## _and_ ## OP2(PTR, VAL)
# else
#  define ATOMIC_OP32(OP1,OP2,PTR,VAL) __atomic_ ## OP1 ## _ ## OP2(PTR, VAL, __ATOMIC_SEQ_CST)
# endif
#endif

#define HAVE_ATOMICS_64 1
#define HAVE_ATOMICS_64_SYNC 0

#if (HAVE_ATOMICS_64)
# if (HAVE_ATOMICS_64_SYNC)
#  define ATOMIC_OP64(OP1,OP2,PTR,VAL) __sync_ ## OP1 ## _and_ ## OP2(PTR, VAL)
# else
#  define ATOMIC_OP64(OP1,OP2,PTR,VAL) __atomic_ ## OP1 ## _ ## OP2(PTR, VAL, __ATOMIC_SEQ_CST)
# endif
#endif

#define WITH_PKGCONFIG 0
#define WITH_HDRHISTOGRAM 1
#define WITH_ZLIB 1
#define WITH_CURL 0
#define WITH_OAUTHBEARER_OIDC 0
#define WITH_ZSTD 1
#define WITH_LIBDL 1
#define WITH_PLUGINS 1
#define WITH_SNAPPY 1
#define WITH_SOCKEM 1
#define WITH_SSL 1
#define WITH_SASL 1
#define WITH_SASL_SCRAM 1
#define WITH_SASL_OAUTHBEARER 1
#define WITH_SASL_CYRUS 0
#define WITH_LZ4_EXT 1
#define HAVE_REGEX 1
#define HAVE_STRNDUP 1
#define HAVE_RAND_R 1
#define HAVE_PTHREAD_SETNAME_GNU 0
#define HAVE_PTHREAD_SETNAME_DARWIN 1
#define HAVE_PTHREAD_SETNAME_FREEBSD 0
#define WITH_C11THREADS 0
#define WITH_CRC32C_HW 0
#define SOLIB_EXT ".dylib"
#define BUILT_WITH "BAZEL"
EOF
""",
        "//conditions:default": """
cat > $@ << 'EOF'
#define WITHOUT_OPTIMIZATION 0
#define ENABLE_DEVEL 0
#define ENABLE_REFCNT_DEBUG 0

#define HAVE_ATOMICS_32 1
#define HAVE_ATOMICS_32_SYNC 0

#if (HAVE_ATOMICS_32)
# if (HAVE_ATOMICS_32_SYNC)
#  define ATOMIC_OP32(OP1,OP2,PTR,VAL) __sync_ ## OP1 ## _and_ ## OP2(PTR, VAL)
# else
#  define ATOMIC_OP32(OP1,OP2,PTR,VAL) __atomic_ ## OP1 ## _ ## OP2(PTR, VAL, __ATOMIC_SEQ_CST)
# endif
#endif

#define HAVE_ATOMICS_64 1
#define HAVE_ATOMICS_64_SYNC 0

#if (HAVE_ATOMICS_64)
# if (HAVE_ATOMICS_64_SYNC)
#  define ATOMIC_OP64(OP1,OP2,PTR,VAL) __sync_ ## OP1 ## _and_ ## OP2(PTR, VAL)
# else
#  define ATOMIC_OP64(OP1,OP2,PTR,VAL) __atomic_ ## OP1 ## _ ## OP2(PTR, VAL, __ATOMIC_SEQ_CST)
# endif
#endif

#define WITH_PKGCONFIG 0
#define WITH_HDRHISTOGRAM 1
#define WITH_ZLIB 1
#define WITH_CURL 0
#define WITH_OAUTHBEARER_OIDC 0
#define WITH_ZSTD 1
#define WITH_LIBDL 1
#define WITH_PLUGINS 1
#define WITH_SNAPPY 1
#define WITH_SOCKEM 1
#define WITH_SSL 1
#define WITH_SASL 1
#define WITH_SASL_SCRAM 1
#define WITH_SASL_OAUTHBEARER 1
#define WITH_SASL_CYRUS 0
#define WITH_LZ4_EXT 1
#define HAVE_REGEX 1
#define HAVE_STRNDUP 1
#define HAVE_RAND_R 1
#define HAVE_PTHREAD_SETNAME_GNU 1
#define HAVE_PTHREAD_SETNAME_DARWIN 0
#define HAVE_PTHREAD_SETNAME_FREEBSD 0
#define WITH_C11THREADS 1
#define WITH_CRC32C_HW 1
#define SOLIB_EXT ".so"
#define BUILT_WITH "BAZEL"
EOF
""",
    }),
)

# Public headers exposed as librdkafka/rdkafka.h and librdkafka/rdkafkacpp.h
genrule(
    name = "generate_public_headers",
    srcs = [
        "src/rdkafka.h",
        "src/rdkafka_mock.h",
        "src-cpp/rdkafkacpp.h",
    ],
    outs = [
        "include/librdkafka/rdkafka.h",
        "include/librdkafka/rdkafka_mock.h",
        "include/librdkafka/rdkafkacpp.h",
    ],
    cmd = """
mkdir -p $(@D)/include/librdkafka
cp $(location src/rdkafka.h) $(@D)/include/librdkafka/rdkafka.h
cp $(location src/rdkafka_mock.h) $(@D)/include/librdkafka/rdkafka_mock.h
cp $(location src-cpp/rdkafkacpp.h) $(@D)/include/librdkafka/rdkafkacpp.h
""",
)

# C library: librdkafka
cc_library(
    name = "rdkafka_c",
    srcs = [
        # Core sources
        "src/crc32c.c",
        "src/rdaddr.c",
        "src/rdavl.c",
        "src/rdbuf.c",
        "src/rdcrc32.c",
        "src/rdfnv1a.c",
        "src/rdbase64.c",
        "src/rdkafka.c",
        "src/rdkafka_assignor.c",
        "src/rdkafka_broker.c",
        "src/rdkafka_buf.c",
        "src/rdkafka_cgrp.c",
        "src/rdkafka_conf.c",
        "src/rdkafka_event.c",
        "src/rdkafka_feature.c",
        "src/rdkafka_lz4.c",
        "src/rdkafka_metadata.c",
        "src/rdkafka_metadata_cache.c",
        "src/rdkafka_msg.c",
        "src/rdkafka_msgset_reader.c",
        "src/rdkafka_msgset_writer.c",
        "src/rdkafka_offset.c",
        "src/rdkafka_op.c",
        "src/rdkafka_partition.c",
        "src/rdkafka_pattern.c",
        "src/rdkafka_queue.c",
        "src/rdkafka_range_assignor.c",
        "src/rdkafka_request.c",
        "src/rdkafka_roundrobin_assignor.c",
        "src/rdkafka_sasl.c",
        "src/rdkafka_sasl_plain.c",
        "src/rdkafka_sticky_assignor.c",
        "src/rdkafka_subscription.c",
        "src/rdkafka_assignment.c",
        "src/rdkafka_timer.c",
        "src/rdkafka_topic.c",
        "src/rdkafka_transport.c",
        "src/rdkafka_interceptor.c",
        "src/rdkafka_header.c",
        "src/rdkafka_admin.c",
        "src/rdkafka_aux.c",
        "src/rdkafka_background.c",
        "src/rdkafka_idempotence.c",
        "src/rdkafka_txnmgr.c",
        "src/rdkafka_cert.c",
        "src/rdkafka_coord.c",
        "src/rdkafka_mock.c",
        "src/rdkafka_mock_handlers.c",
        "src/rdkafka_mock_cgrp.c",
        "src/rdkafka_error.c",
        "src/rdkafka_fetcher.c",
        "src/rdkafka_telemetry.c",
        "src/rdkafka_telemetry_decode.c",
        "src/rdkafka_telemetry_encode.c",
        "src/nanopb/pb_encode.c",
        "src/nanopb/pb_decode.c",
        "src/nanopb/pb_common.c",
        "src/opentelemetry/metrics.pb.c",
        "src/opentelemetry/common.pb.c",
        "src/opentelemetry/resource.pb.c",
        "src/rdlist.c",
        "src/rdlog.c",
        "src/rdmurmur2.c",
        "src/rdports.c",
        "src/rdrand.c",
        "src/rdregex.c",
        "src/rdstring.c",
        "src/rdunittest.c",
        "src/rdvarint.c",
        "src/rdmap.c",
        "src/snappy.c",
        "src/tinycthread.c",
        "src/tinycthread_extra.c",
        "src/rdxxhash.c",
        "src/cJSON.c",
        # WITH_SSL
        "src/rdkafka_ssl.c",
        # WITH_HDRHISTOGRAM
        "src/rdhdrhistogram.c",
        # WITH_LIBDL
        "src/rddl.c",
        # WITH_PLUGINS
        "src/rdkafka_plugin.c",
        # WITH_SASL_SCRAM
        "src/rdkafka_sasl_scram.c",
        # WITH_SASL_OAUTHBEARER
        "src/rdkafka_sasl_oauthbearer.c",
        # WITH_ZLIB
        "src/rdgz.c",
        # WITH_ZSTD
        "src/rdkafka_zstd.c",
        # Generated config
        ":generate_config_h",
    ],
    hdrs = [
        "include/librdkafka/rdkafka.h",
        "include/librdkafka/rdkafka_mock.h",
    ],
    copts = [
        "-DLIBRDKAFKA_STATICLIB",
        "-fPIC",
    ] + select({
        "@platforms//os:macos": ["-D_DARWIN_C_SOURCE"],
        "//conditions:default": ["-D_GNU_SOURCE"],
    }),
    includes = [
        ".",
        "include",
        "src",
    ],
    linkopts = select({
        "@platforms//os:macos": ["-ldl", "-lm", "-lsasl2"],
        "//conditions:default": ["-ldl", "-lm", "-lpthread"],
    }),
    textual_hdrs = glob(
        [
            "src/**/*.h",
        ],
    ),
    deps = [
        "@openssl//:openssl",
        "@zlib",
        "@zstd//:zstd",
        "@lz4//:lz4",
    ],
)

# C++ wrapper: librdkafka++
cc_library(
    name = "rdkafka_cpp",
    srcs = [
        "src-cpp/ConfImpl.cpp",
        "src-cpp/ConsumerImpl.cpp",
        "src-cpp/HandleImpl.cpp",
        "src-cpp/HeadersImpl.cpp",
        "src-cpp/KafkaConsumerImpl.cpp",
        "src-cpp/MessageImpl.cpp",
        "src-cpp/MetadataImpl.cpp",
        "src-cpp/ProducerImpl.cpp",
        "src-cpp/QueueImpl.cpp",
        "src-cpp/RdKafka.cpp",
        "src-cpp/TopicImpl.cpp",
        "src-cpp/TopicPartitionImpl.cpp",
    ],
    hdrs = [
        "include/librdkafka/rdkafkacpp.h",
    ],
    copts = [
        "-DLIBRDKAFKA_STATICLIB",
        "-fPIC",
    ],
    includes = [
        "include",
        "src-cpp",
    ],
    textual_hdrs = [
        "src-cpp/rdkafkacpp.h",
        "src-cpp/rdkafkacpp_int.h",
    ],
    deps = [
        ":rdkafka_c",
    ],
)

# Aggregated target matching the old rules_foreign_cc name
cc_library(
    name = "librdkafka",
    deps = [
        ":rdkafka_c",
        ":rdkafka_cpp",
    ],
)
