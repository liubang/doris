load("@rules_foreign_cc//foreign_cc:defs.bzl", "cmake")

filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
)

cmake(
    name = "libbase64",
    lib_source = ":all_srcs",
    out_static_libs = ["libbase64.a"],
    out_include_dir = "include",
    visibility = ["//visibility:public"],
)
