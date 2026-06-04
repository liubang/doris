# fmt 7.1.3 - A modern formatting library
# Doris requires fmt 7.x (fmt 11.x has breaking consteval format string changes)

package(default_visibility = ["//visibility:public"])

cc_library(
    name = "fmt",
    srcs = [
        "src/format.cc",
        "src/os.cc",
    ],
    hdrs = glob(["include/fmt/*.h"]),
    includes = ["include"],
    copts = ["-std=c++20"],
)
