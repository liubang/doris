# libunwind 1.6.2 - Stack unwinding library
# Built via configure_make using rules_foreign_cc

load("@rules_foreign_cc//foreign_cc:defs.bzl", "configure_make")

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
)

configure_make(
    name = "libunwind",
    args = ["-j"],
    configure_options = [
        "--disable-shared",
        "--enable-static",
        "--disable-minidebuginfo",
        "--disable-zlibdebuginfo",
    ],
    lib_source = ":all_srcs",
    out_static_libs = ["libunwind.a"],
)
