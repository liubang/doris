# AWS SDK C++ - Built via CMake using rules_foreign_cc
# Only builds core, s3, and transfer components needed by Doris

load("@rules_foreign_cc//foreign_cc:defs.bzl", "cmake")

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
)

cmake(
    name = "aws_sdk",
    build_args = ["-j"],
    cache_entries = {
        "CMAKE_BUILD_TYPE": "Release",
        "BUILD_SHARED_LIBS": "OFF",
        "BUILD_ONLY": "s3;transfer;identity-management;sts",
        "ENABLE_TESTING": "OFF",
        "AUTORUN_UNIT_TESTS": "OFF",
        "MINIMIZE_SIZE": "ON",
        "ENABLE_UNITY_BUILD": "ON",
        "FORCE_SHARED_CRT": "OFF",
        "CPP_STANDARD": "17",
        # BUILD_DEPS downloads CRT dependencies during cmake configure
        "BUILD_DEPS": "ON",
    },
    # Allow network access for BUILD_DEPS to download CRT submodules
    tags = ["requires-network"],
    lib_source = ":all_srcs",
    out_static_libs = [
        "libaws-cpp-sdk-s3.a",
        "libaws-cpp-sdk-transfer.a",
        "libaws-cpp-sdk-identity-management.a",
        "libaws-cpp-sdk-sts.a",
        "libaws-cpp-sdk-core.a",
        "libaws-crt-cpp.a",
        "libaws-c-s3.a",
        "libaws-c-auth.a",
        "libaws-c-http.a",
        "libaws-c-io.a",
        "libaws-c-cal.a",
        "libaws-c-compression.a",
        "libaws-c-sdkutils.a",
        "libaws-c-common.a",
        "libaws-checksums.a",
        "libs2n.a",
    ],
    linkopts = select({
        "@platforms//os:macos": [
            "-framework CoreFoundation",
            "-framework Security",
        ],
        "//conditions:default": [],
    }),
    deps = [
        "@boringssl//:crypto",
        "@boringssl//:ssl",
        "@curl",
        "@zlib",
    ],
)
