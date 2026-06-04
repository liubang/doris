package(default_visibility = ["//visibility:public"])

cc_library(
    name = "cctz",
    srcs = glob(
        ["src/*.cc", "src/*.h"],
        exclude = ["src/*_test.cc", "src/*_benchmark.cc"],
    ),
    hdrs = glob(["include/**/*.h"]),
    includes = ["include", "src"],
)
