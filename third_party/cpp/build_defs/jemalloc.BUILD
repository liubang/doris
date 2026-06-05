# jemalloc 5.3.0 - Memory allocator
# Hand-written cc_library BUILD file (replaces rules_foreign_cc configure_make)
#
# Configure options used to generate platform headers:
#   --with-jemalloc-prefix=je_ --enable-prof --disable-cxx
#   --disable-libdl --disable-initial-exec-tls

package(default_visibility = ["//visibility:public"])

# =============================================================================
# Platform detection
# =============================================================================

config_setting(
    name = "linux",
    constraint_values = ["@platforms//os:linux"],
)

config_setting(
    name = "macos",
    constraint_values = ["@platforms//os:macos"],
)

# =============================================================================
# Source files
# =============================================================================

# All source files except zone.c (macOS-only)
_COMMON_SRCS = [
    "src/jemalloc.c",
    "src/arena.c",
    "src/background_thread.c",
    "src/base.c",
    "src/bin.c",
    "src/bin_info.c",
    "src/bitmap.c",
    "src/buf_writer.c",
    "src/cache_bin.c",
    "src/ckh.c",
    "src/counter.c",
    "src/ctl.c",
    "src/decay.c",
    "src/div.c",
    "src/ecache.c",
    "src/edata.c",
    "src/edata_cache.c",
    "src/ehooks.c",
    "src/emap.c",
    "src/eset.c",
    "src/exp_grow.c",
    "src/extent.c",
    "src/extent_dss.c",
    "src/extent_mmap.c",
    "src/fxp.c",
    "src/hook.c",
    "src/hpa.c",
    "src/hpa_hooks.c",
    "src/hpdata.c",
    "src/inspect.c",
    "src/large.c",
    "src/log.c",
    "src/malloc_io.c",
    "src/mutex.c",
    "src/nstime.c",
    "src/pa.c",
    "src/pa_extra.c",
    "src/pac.c",
    "src/pages.c",
    "src/pai.c",
    "src/peak_event.c",
    "src/prof.c",
    "src/prof_data.c",
    "src/prof_log.c",
    "src/prof_recent.c",
    "src/prof_stats.c",
    "src/prof_sys.c",
    "src/psset.c",
    "src/rtree.c",
    "src/safety_check.c",
    "src/san.c",
    "src/san_bump.c",
    "src/sc.c",
    "src/sec.c",
    "src/stats.c",
    "src/sz.c",
    "src/tcache.c",
    "src/test_hooks.c",
    "src/thread_event.c",
    "src/ticker.c",
    "src/tsd.c",
    "src/witness.c",
]

# =============================================================================
# Main library
# =============================================================================

cc_library(
    name = "jemalloc",
    srcs = _COMMON_SRCS + select({
        ":macos": ["src/zone.c"],
        "//conditions:default": [],
    }),
    hdrs = glob([
        "include/jemalloc/internal/**/*.h",
    ]),
    copts = [
        "-std=gnu11",
        "-D_REENTRANT",
        "-Wall",
        "-Wextra",
        "-Wsign-compare",
        "-Wundef",
        "-Wno-format-zero-length",
        "-Wpointer-arith",
        "-Wno-missing-braces",
        "-Wno-missing-field-initializers",
        "-Wimplicit-fallthrough",
        "-O3",
        "-funroll-loops",
        "-fno-omit-frame-pointer",
        "-Wno-type-limits",
        "-Wno-unused-parameter",
        "-Wno-frame-address",
    ] + select({
        ":macos": ["-Wshorten-64-to-32"],
        "//conditions:default": [],
    }),
    includes = ["include"],
    local_defines = [
        "_REENTRANT",
    ],
    deps = [
        "@doris//third_party/cpp/generated/jemalloc:jemalloc_generated_headers",
    ],
)
