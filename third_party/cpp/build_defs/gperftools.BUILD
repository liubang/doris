# gperftools 2.10 - tcmalloc and profiling tools
# Built via configure_make using rules_foreign_cc

load("@rules_foreign_cc//foreign_cc:defs.bzl", "configure_make")

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
)

configure_make(
    name = "gperftools",
    args = [
        "-j",
        "noinst_PROGRAMS=",
        "check_PROGRAMS=",
    ],
    configure_options = [
        "--disable-shared",
        "--enable-static",
        "--enable-frame-pointers",
        "--disable-libunwind",
    ],
    env = select({
        "@platforms//os:macos": {"AR": "/usr/bin/ar"},
        "//conditions:default": {},
    }),
    lib_source = ":all_srcs",
    out_static_libs = [
        "libtcmalloc.a",
        "libprofiler.a",
    ],
)
