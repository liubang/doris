# OpenSSL 1.1.1s - TLS/crypto library
# Built via Configure (perl-based) using configure_make
# Note: Using no-asm on ARM64 to avoid inline assembly issues with newer Clang
# Note: On macOS, we must override AR to avoid the libtool vs ar conflict
# Note: rules_foreign_cc automatically adds --prefix=<installdir>

load("@rules_foreign_cc//foreign_cc:defs.bzl", "configure_make")

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
)

configure_make(
    name = "openssl",
    args = ["-j4"],
    configure_command = "Configure",
    configure_options = select({
        "@platforms//cpu:aarch64": [
            "darwin64-arm64-cc",
            "no-shared",
            "no-tests",
            "no-asm",
            "-fPIC",
            "-w",
        ],
        "@platforms//cpu:x86_64": [
            "darwin64-x86_64-cc",
            "no-shared",
            "no-tests",
            "-fPIC",
            "-w",
        ],
        "//conditions:default": [
            "linux-x86_64",
            "no-shared",
            "no-tests",
            "-fPIC",
            "-w",
        ],
    }),
    env = select({
        "@platforms//os:macos": {
            "AR": "/usr/bin/ar",
            "KERNEL_BITS": "64",
        },
        "//conditions:default": {},
    }),
    lib_source = ":all_srcs",
    out_static_libs = [
        "libssl.a",
        "libcrypto.a",
    ],
    targets = [
        "build_libs",
        "install_dev",
    ],
)
