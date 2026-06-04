# libevent 2.1.12 - Event notification library
# Built via CMake using rules_foreign_cc

load("@rules_foreign_cc//foreign_cc:defs.bzl", "cmake")

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
)

cmake(
    name = "libevent",
    build_args = ["-j"],
    cache_entries = {
        "CMAKE_BUILD_TYPE": "Release",
        "EVENT__DISABLE_BENCHMARK": "ON",
        "EVENT__DISABLE_TESTS": "ON",
        "EVENT__DISABLE_REGRESS": "ON",
        "EVENT__DISABLE_SAMPLES": "ON",
        "EVENT__LIBRARY_TYPE": "STATIC",
        "OPENSSL_ROOT_DIR": "",
    },
    lib_source = ":all_srcs",
    out_static_libs = [
        "libevent.a",
        "libevent_core.a",
        "libevent_extra.a",
        "libevent_pthreads.a",
    ],
    deps = ["@openssl//:openssl"],
)
