load("@rules_cc//cc:defs.bzl", "cc_library")

package(default_visibility = ["//visibility:public"])

cc_library(
    name = "bitshuffle",
    srcs = [
        "src/bitshuffle.c",
        "src/bitshuffle_core.c",
        "src/iochain.c",
    ],
    hdrs = [
        "src/bitshuffle.h",
        "src/bitshuffle_core.h",
        "src/bitshuffle_internals.h",
        "src/iochain.h",
    ],
    # Doris includes as <bitshuffle/bitshuffle.h>, so we use include_prefix
    # to make headers available under bitshuffle/ prefix
    include_prefix = "bitshuffle",
    strip_include_prefix = "src",
    copts = [
        "-std=c99",
        "-O3",
    ],
    deps = ["@lz4//:lz4"],
)
