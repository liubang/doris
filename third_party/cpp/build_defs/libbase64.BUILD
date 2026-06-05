# aklomp/base64 0.5.2 - Fast base64 encoding/decoding with SIMD
# 手写 cc_library 版（替代原 rules_foreign_cc cmake）
#
# 背景：
#   libbase64 通过运行时 CPU 检测选择最优 SIMD codec（SSSE3/SSE41/AVX/AVX2/AVX512/NEON64）。
#   每个架构的 codec.c 需要用对应的编译标志（如 -mssse3）单独编译。
#   CMake 通过 config.h 控制启用哪些 codec，通过 set_source_files_properties 设置 per-file copt。
#
# 本方案：
#   1. 用 genrule 生成平台特定的 config.h
#   2. 每个 SIMD codec 用独立 cc_library（per-file copt）
#   3. 通用代码 + 所有 codec 聚合为最终 :libbase64 target
#
# 注意：Doris 有 patch 把 base64_encode → do_base64_encode, base64_decode → do_base64_decode

load("@rules_cc//cc:defs.bzl", "cc_library")

package(default_visibility = ["//visibility:public"])

# =============================================================================
# Step 1: 生成 config.h（平台特定）
# 放到 lib/ 子目录下，因为源码用 #include "config.h" 相对于 lib/ 搜索
# =============================================================================

genrule(
    name = "gen_config_h",
    outs = ["lib/config.h"],
    cmd = select({
        "@platforms//cpu:aarch64": """
cat > $@ << 'EOF'
#ifndef BASE64_CONFIG_H
#define BASE64_CONFIG_H
#define BASE64_WITH_SSSE3 0
#define HAVE_SSSE3 0
#define BASE64_WITH_SSE41 0
#define HAVE_SSE41 0
#define BASE64_WITH_SSE42 0
#define HAVE_SSE42 0
#define BASE64_WITH_AVX 0
#define HAVE_AVX 0
#define BASE64_WITH_AVX2 0
#define HAVE_AVX2 0
#define BASE64_WITH_AVX512 0
#define HAVE_AVX512 0
#define BASE64_WITH_NEON32 0
#define HAVE_NEON32 0
#define BASE64_WITH_NEON64 1
#define HAVE_NEON64 1
#endif
EOF
""",
        # x86_64 config: 启用所有 x86 SIMD，禁用 NEON
        "//conditions:default": """
cat > $@ << 'EOF'
#ifndef BASE64_CONFIG_H
#define BASE64_CONFIG_H
#define BASE64_WITH_SSSE3 1
#define HAVE_SSSE3 1
#define BASE64_WITH_SSE41 1
#define HAVE_SSE41 1
#define BASE64_WITH_SSE42 1
#define HAVE_SSE42 1
#define BASE64_WITH_AVX 1
#define HAVE_AVX 1
#define BASE64_WITH_AVX2 1
#define HAVE_AVX2 1
#define BASE64_WITH_AVX512 1
#define HAVE_AVX512 1
#define BASE64_WITH_NEON32 0
#define HAVE_NEON32 0
#define BASE64_WITH_NEON64 0
#define HAVE_NEON64 0
#endif
EOF
""",
    }),
)

# =============================================================================
# Step 2: 被 textual include 的 .c 文件集合
# =============================================================================

_TEXTUAL_HDRS = [
    # generic
    "lib/arch/generic/32/dec_loop.c",
    "lib/arch/generic/32/enc_loop.c",
    "lib/arch/generic/64/enc_loop.c",
    "lib/arch/generic/dec_head.c",
    "lib/arch/generic/dec_tail.c",
    "lib/arch/generic/enc_head.c",
    "lib/arch/generic/enc_tail.c",
    # ssse3
    "lib/arch/ssse3/dec_loop.c",
    "lib/arch/ssse3/dec_reshuffle.c",
    "lib/arch/ssse3/enc_loop.c",
    "lib/arch/ssse3/enc_loop_asm.c",
    "lib/arch/ssse3/enc_reshuffle.c",
    "lib/arch/ssse3/enc_translate.c",
    # avx
    "lib/arch/avx/enc_loop_asm.c",
    # avx2
    "lib/arch/avx2/dec_loop.c",
    "lib/arch/avx2/dec_reshuffle.c",
    "lib/arch/avx2/enc_loop.c",
    "lib/arch/avx2/enc_loop_asm.c",
    "lib/arch/avx2/enc_reshuffle.c",
    "lib/arch/avx2/enc_translate.c",
    # avx512
    "lib/arch/avx512/enc_loop.c",
    "lib/arch/avx512/enc_reshuffle_translate.c",
    # neon32
    "lib/arch/neon32/dec_loop.c",
    "lib/arch/neon32/enc_loop.c",
    "lib/arch/neon32/enc_reshuffle.c",
    "lib/arch/neon32/enc_translate.c",
    # neon64
    "lib/arch/neon64/dec_loop.c",
    "lib/arch/neon64/enc_loop.c",
    "lib/arch/neon64/enc_loop_asm.c",
    "lib/arch/neon64/enc_reshuffle.c",
]

# 内部头文件（源码树中的）
# 注意：include/libbase64.h 也需要在这里，因为 codec.c 用相对路径
# #include "../../../include/libbase64.h" 引用它，Bazel 需要知道这个依赖
# 才会把文件放入 sandbox
_INTERNAL_HDRS = [
    "include/libbase64.h",
    "lib/codecs.h",
    "lib/env.h",
    "lib/tables/tables.h",
    "lib/tables/table_dec_32bit.h",
    "lib/tables/table_enc_12bit.h",
]

# =============================================================================
# Step 3: 通用 copts
# =============================================================================

# genrule 输出 lib/config.h 到 $(GENDIR)/external/+cpp_deps+libbase64/lib/config.h
# 源码中 #include "config.h" 从 lib/ 目录搜索，需要 -iquote 指向 genfiles 中的 lib/
_BASE_COPTS = [
    "-std=c99",
    # 让 #include "config.h" 能找到生成的 config.h
    # genrule 输出到 $(GENDIR)/external/+cpp_deps+libbase64/lib/config.h
    # 各 codec.c 在 lib/arch/xxx/ 下，用 #include "config.h" 搜索时
    # 需要 -iquote 指向包含 config.h 的目录
    "-iquote$(GENDIR)/external/+cpp_deps+libbase64/lib",
    # 内部头文件搜索（codecs.h, env.h 在 lib/ 下）
    "-iquote$(BINDIR)/external/+cpp_deps+libbase64/lib",
    "-iquoteexternal/+cpp_deps+libbase64/lib",
]

# =============================================================================
# Step 4: 各架构 codec 独立编译
# =============================================================================

# Generic codec（所有平台都编译）
cc_library(
    name = "codec_generic",
    srcs = ["lib/arch/generic/codec.c"] + _INTERNAL_HDRS,
    textual_hdrs = _TEXTUAL_HDRS + [":gen_config_h"],
    copts = _BASE_COPTS,
    includes = ["include"],
    visibility = ["//visibility:private"],
)

# NEON64 codec（ARM64 only）
cc_library(
    name = "codec_neon64",
    srcs = select({
        "@platforms//cpu:aarch64": ["lib/arch/neon64/codec.c"],
        "//conditions:default": [],
    }) + _INTERNAL_HDRS,
    textual_hdrs = _TEXTUAL_HDRS + [":gen_config_h"],
    copts = _BASE_COPTS,
    includes = ["include"],
    visibility = ["//visibility:private"],
)

# NEON32 codec（32-bit ARM only，其他平台编译为 stub）
cc_library(
    name = "codec_neon32",
    srcs = ["lib/arch/neon32/codec.c"] + _INTERNAL_HDRS,
    textual_hdrs = _TEXTUAL_HDRS + [":gen_config_h"],
    copts = _BASE_COPTS,
    includes = ["include"],
    visibility = ["//visibility:private"],
)

# SSSE3 codec（x86_64 only）
cc_library(
    name = "codec_ssse3",
    srcs = select({
        "@platforms//cpu:aarch64": [],
        "//conditions:default": ["lib/arch/ssse3/codec.c"],
    }) + _INTERNAL_HDRS,
    textual_hdrs = _TEXTUAL_HDRS + [":gen_config_h"],
    copts = _BASE_COPTS + select({
        "@platforms//cpu:aarch64": [],
        "//conditions:default": ["-mssse3"],
    }),
    includes = ["include"],
    visibility = ["//visibility:private"],
)

# SSE4.1 codec
cc_library(
    name = "codec_sse41",
    srcs = select({
        "@platforms//cpu:aarch64": [],
        "//conditions:default": ["lib/arch/sse41/codec.c"],
    }) + _INTERNAL_HDRS,
    textual_hdrs = _TEXTUAL_HDRS + [":gen_config_h"],
    copts = _BASE_COPTS + select({
        "@platforms//cpu:aarch64": [],
        "//conditions:default": ["-msse4.1"],
    }),
    includes = ["include"],
    visibility = ["//visibility:private"],
)

# SSE4.2 codec
cc_library(
    name = "codec_sse42",
    srcs = select({
        "@platforms//cpu:aarch64": [],
        "//conditions:default": ["lib/arch/sse42/codec.c"],
    }) + _INTERNAL_HDRS,
    textual_hdrs = _TEXTUAL_HDRS + [":gen_config_h"],
    copts = _BASE_COPTS + select({
        "@platforms//cpu:aarch64": [],
        "//conditions:default": ["-msse4.2"],
    }),
    includes = ["include"],
    visibility = ["//visibility:private"],
)

# AVX codec
cc_library(
    name = "codec_avx",
    srcs = select({
        "@platforms//cpu:aarch64": [],
        "//conditions:default": ["lib/arch/avx/codec.c"],
    }) + _INTERNAL_HDRS,
    textual_hdrs = _TEXTUAL_HDRS + [":gen_config_h"],
    copts = _BASE_COPTS + select({
        "@platforms//cpu:aarch64": [],
        "//conditions:default": ["-mavx"],
    }),
    includes = ["include"],
    visibility = ["//visibility:private"],
)

# AVX2 codec
cc_library(
    name = "codec_avx2",
    srcs = select({
        "@platforms//cpu:aarch64": [],
        "//conditions:default": ["lib/arch/avx2/codec.c"],
    }) + _INTERNAL_HDRS,
    textual_hdrs = _TEXTUAL_HDRS + [":gen_config_h"],
    copts = _BASE_COPTS + select({
        "@platforms//cpu:aarch64": [],
        "//conditions:default": ["-mavx2"],
    }),
    includes = ["include"],
    visibility = ["//visibility:private"],
)

# AVX512 codec
cc_library(
    name = "codec_avx512",
    srcs = select({
        "@platforms//cpu:aarch64": [],
        "//conditions:default": ["lib/arch/avx512/codec.c"],
    }) + _INTERNAL_HDRS,
    textual_hdrs = _TEXTUAL_HDRS + [":gen_config_h"],
    copts = _BASE_COPTS + select({
        "@platforms//cpu:aarch64": [],
        "//conditions:default": ["-mavx512vl", "-mavx512bw"],
    }),
    includes = ["include"],
    visibility = ["//visibility:private"],
)

# =============================================================================
# Step 5: 主库聚合
# =============================================================================

cc_library(
    name = "libbase64",
    srcs = [
        "lib/lib.c",
        "lib/codec_choose.c",
        "lib/tables/tables.c",
    ] + _INTERNAL_HDRS,
    hdrs = ["include/libbase64.h"],
    textual_hdrs = _TEXTUAL_HDRS + [":gen_config_h"],
    copts = _BASE_COPTS,
    includes = ["include"],
    local_defines = ["BASE64_STATIC_DEFINE"],
    deps = [
        ":codec_generic",
        ":codec_neon64",
        ":codec_neon32",
        ":codec_ssse3",
        ":codec_sse41",
        ":codec_sse42",
        ":codec_avx",
        ":codec_avx2",
        ":codec_avx512",
    ],
    visibility = ["//visibility:public"],
)
