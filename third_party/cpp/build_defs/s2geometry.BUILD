# S2 Geometry 0.10.0 - Spherical geometry library
# Built via CMake using rules_foreign_cc

load("@rules_foreign_cc//foreign_cc:defs.bzl", "cmake")

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
)

cmake(
    name = "s2geometry",
    build_args = ["-j"],
    cache_entries = {
        "CMAKE_BUILD_TYPE": "Release",
        "BUILD_SHARED_LIBS": "OFF",
        "BUILD_TESTS": "OFF",
        "BUILD_EXAMPLES": "OFF",
        "WITH_PYTHON": "OFF",
        "CMAKE_CXX_STANDARD": "20",
        "S2_USE_GLOG": "OFF",
        "S2_USE_GFLAGS": "OFF",
    },
    lib_source = ":all_srcs",
    out_static_libs = ["libs2.a"],
    deps = [
        "@abseil-cpp//absl/base",
        "@abseil-cpp//absl/container:btree",
        "@abseil-cpp//absl/container:flat_hash_map",
        "@abseil-cpp//absl/container:flat_hash_set",
        "@abseil-cpp//absl/hash",
        "@abseil-cpp//absl/log",
        "@abseil-cpp//absl/memory",
        "@abseil-cpp//absl/numeric:int128",
        "@abseil-cpp//absl/strings",
        "@abseil-cpp//absl/types:span",
        "@abseil-cpp//absl/utility",
        "@openssl//:openssl",
    ],
)
