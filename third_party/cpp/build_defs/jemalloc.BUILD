# jemalloc 5.3.0 - Memory allocator
# Built via configure_make using rules_foreign_cc

load("@rules_foreign_cc//foreign_cc:defs.bzl", "configure_make")

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
)

configure_make(
    name = "jemalloc",
    args = ["-j"],
    configure_options = [
        "--disable-shared",
        "--enable-static",
        "--with-jemalloc-prefix=je_",
        "--enable-prof",
        "--disable-cxx",
        "--disable-libdl",
        "--disable-initial-exec-tls",
    ],
    env = select({
        "@platforms//os:macos": {
            # On macOS, jemalloc's Makefile uses AR for creating static libs.
            # Force using /usr/bin/ar instead of libtool to avoid
            # "libtool: no output file (-o) specified" errors.
            "AR": "/usr/bin/ar",
            "RANLIB": "/usr/bin/ranlib",
        },
        "//conditions:default": {},
    }),
    lib_source = ":all_srcs",
    out_static_libs = ["libjemalloc.a"],
    targets = ["install_lib install_include"],
)
