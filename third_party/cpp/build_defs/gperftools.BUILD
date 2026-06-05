# gperftools 2.10 - Google Performance Tools (tcmalloc + cpu profiler)
# Hand-written cc_library BUILD file (replaces rules_foreign_cc configure_make)

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
# Generated config headers
# =============================================================================

# config.h - replaces autoconf configure step
genrule(
    name = "gen_config_h",
    outs = ["src/config.h"],
    cmd = select({
        ":linux": """cat > $@ << 'EOF'
#ifndef GPERFTOOLS_CONFIG_H_
#define GPERFTOOLS_CONFIG_H_

/* gperftools 2.10 - generated for Linux x86_64 */

#define ENABLE_AGGRESSIVE_DECOMMIT_BY_DEFAULT 1
/* #undef ENABLE_ALIGNED_NEW_DELETE */
/* #undef ENABLE_DYNAMIC_SIZED_DELETE */
/* #undef ENABLE_LARGE_ALLOC_REPORT */
/* #undef ENABLE_SIZED_DELETE */

/* #undef HAVE_ASM_PTRACE_H */
/* #undef HAVE_CONFLICT_SIGNAL_H */
#define HAVE_CXX11 1
/* #undef HAVE_CYGWIN_SIGNAL_H */
#define HAVE_DECL_BACKTRACE 1
#define HAVE_DECL_CFREE 1
#define HAVE_DECL_MEMALIGN 1
#define HAVE_DECL_NANOSLEEP 1
#define HAVE_DECL_POSIX_MEMALIGN 1
#define HAVE_DECL_PVALLOC 1
#define HAVE_DECL_SLEEP 1
#define HAVE_DECL_VALLOC 1
#define HAVE_DLFCN_H 1
/* #undef HAVE_ELF32_VERSYM */
#define HAVE_EXECINFO_H 1
#define HAVE_FCNTL_H 1
#define HAVE_FEATURES_H 1
#define HAVE_FORK 1
#define HAVE_GETEUID 1
#define HAVE_GLOB_H 1
#define HAVE_GRP_H 1
#define HAVE_INTTYPES_H 1
/* #undef HAVE_LIBUNWIND_H */
#define HAVE_LINUX_PTRACE_H 1
#define HAVE_LINUX_SIGEV_THREAD_ID 1
#define HAVE_MALLOC_H 1
#define HAVE_MMAP 1
/* #undef HAVE_POLL_H */
#define HAVE_PROGRAM_INVOCATION_NAME 1
#define HAVE_PTHREAD 1
/* #undef HAVE_PTHREAD_DESPITE_ASKING_FOR */
#define HAVE_PWD_H 1
#define HAVE_SBRK 1
#define HAVE_SCHED_H 1
#define HAVE_STDINT_H 1
#define HAVE_STDIO_H 1
#define HAVE_STDLIB_H 1
#define HAVE_STRINGS_H 1
#define HAVE_STRING_H 1
#define HAVE_STRUCT_MALLINFO 1
#define HAVE_SYS_CDEFS_H 1
/* #undef HAVE_SYS_MALLOC_H */
#define HAVE_SYS_PARAM_H 1
#define HAVE_SYS_PRCTL_H 1
#define HAVE_SYS_RESOURCE_H 1
#define HAVE_SYS_SOCKET_H 1
#define HAVE_SYS_STAT_H 1
#define HAVE_SYS_SYSCALL_H 1
#define HAVE_SYS_TYPES_H 1
#define HAVE_SYS_UCONTEXT_H 1
/* #undef HAVE_SYS_WAIT_H */
#define HAVE_TLS 1
#define HAVE_UCONTEXT_H 1
#define HAVE_UNISTD_H 1
#define HAVE_UNWIND_BACKTRACE 1
#define HAVE_UNWIND_H 1
#define HAVE___ATTRIBUTE__ 1
#define HAVE___ATTRIBUTE__ALIGNED_FN 1
#define HAVE___ENVIRON 1
#define HAVE___SBRK 1

#define INSTALL_PREFIX "/usr/local"
/* #undef INT32_EQUALS_INTPTR */
#define LT_OBJDIR ".libs/"
#define PACKAGE "gperftools"
#define PACKAGE_BUGREPORT "gperftools@googlegroups.com"
#define PACKAGE_NAME "gperftools"
#define PACKAGE_STRING "gperftools 2.10"
#define PACKAGE_TARNAME "gperftools"
#define PACKAGE_URL ""
#define PACKAGE_VERSION "2.10"

#define PC_FROM_UCONTEXT uc_mcontext.gregs[REG_RIP]
#define PERFTOOLS_DLL_DECL
/* #undef PTHREAD_CREATE_JOINABLE */
#define STDC_HEADERS 1
/* #undef TCMALLOC_ALIGN_8BYTES */
/* default page size shift = 15 (32KB pages) */
/* #undef TCMALLOC_PAGE_SIZE_SHIFT */
#define VERSION "2.10"

#ifndef __STDC_FORMAT_MACROS
# define __STDC_FORMAT_MACROS 1
#endif

#endif  /* #ifndef GPERFTOOLS_CONFIG_H_ */
EOF
""",
        ":macos": """cat > $@ << 'EOF'
#ifndef GPERFTOOLS_CONFIG_H_
#define GPERFTOOLS_CONFIG_H_

/* gperftools 2.10 - generated for macOS arm64/x86_64 */

#define ENABLE_AGGRESSIVE_DECOMMIT_BY_DEFAULT 1
/* #undef ENABLE_ALIGNED_NEW_DELETE */
/* #undef ENABLE_DYNAMIC_SIZED_DELETE */
/* #undef ENABLE_LARGE_ALLOC_REPORT */
/* #undef ENABLE_SIZED_DELETE */

/* #undef HAVE_ASM_PTRACE_H */
/* #undef HAVE_CONFLICT_SIGNAL_H */
#define HAVE_CXX11 1
/* #undef HAVE_CYGWIN_SIGNAL_H */
#define HAVE_DECL_BACKTRACE 1
/* #undef HAVE_DECL_CFREE */
/* #undef HAVE_DECL_MEMALIGN */
#define HAVE_DECL_NANOSLEEP 1
#define HAVE_DECL_POSIX_MEMALIGN 1
/* #undef HAVE_DECL_PVALLOC */
#define HAVE_DECL_SLEEP 1
/* #undef HAVE_DECL_VALLOC */
#define HAVE_DLFCN_H 1
/* #undef HAVE_ELF32_VERSYM */
#define HAVE_EXECINFO_H 1
#define HAVE_FCNTL_H 1
/* #undef HAVE_FEATURES_H */
#define HAVE_FORK 1
#define HAVE_GETEUID 1
#define HAVE_GLOB_H 1
#define HAVE_GRP_H 1
#define HAVE_INTTYPES_H 1
/* #undef HAVE_LIBUNWIND_H */
/* #undef HAVE_LINUX_PTRACE_H */
/* #undef HAVE_LINUX_SIGEV_THREAD_ID */
/* #undef HAVE_MALLOC_H */
#define HAVE_MMAP 1
/* #undef HAVE_POLL_H */
/* #undef HAVE_PROGRAM_INVOCATION_NAME */
#define HAVE_PTHREAD 1
/* #undef HAVE_PTHREAD_DESPITE_ASKING_FOR */
#define HAVE_PWD_H 1
/* #undef HAVE_SBRK */
#define HAVE_SCHED_H 1
#define HAVE_STDINT_H 1
#define HAVE_STDIO_H 1
#define HAVE_STDLIB_H 1
#define HAVE_STRINGS_H 1
#define HAVE_STRING_H 1
/* #undef HAVE_STRUCT_MALLINFO */
#define HAVE_SYS_CDEFS_H 1
#define HAVE_SYS_MALLOC_H 1
#define HAVE_SYS_PARAM_H 1
/* #undef HAVE_SYS_PRCTL_H */
#define HAVE_SYS_RESOURCE_H 1
#define HAVE_SYS_SOCKET_H 1
#define HAVE_SYS_STAT_H 1
/* #undef HAVE_SYS_SYSCALL_H */
#define HAVE_SYS_TYPES_H 1
#define HAVE_SYS_UCONTEXT_H 1
/* #undef HAVE_SYS_WAIT_H */
#define HAVE_TLS 1
/* #undef HAVE_UCONTEXT_H */
#define HAVE_UNISTD_H 1
#define HAVE_UNWIND_BACKTRACE 1
#define HAVE_UNWIND_H 1
#define HAVE___ATTRIBUTE__ 1
#define HAVE___ATTRIBUTE__ALIGNED_FN 1
/* #undef HAVE___ENVIRON */
/* #undef HAVE___SBRK */

#define INSTALL_PREFIX "/usr/local"
/* #undef INT32_EQUALS_INTPTR */
#define LT_OBJDIR ".libs/"
#define PACKAGE "gperftools"
#define PACKAGE_BUGREPORT "gperftools@googlegroups.com"
#define PACKAGE_NAME "gperftools"
#define PACKAGE_STRING "gperftools 2.10"
#define PACKAGE_TARNAME "gperftools"
#define PACKAGE_URL ""
#define PACKAGE_VERSION "2.10"

#if defined(__aarch64__) || defined(__arm64__)
#define PC_FROM_UCONTEXT uc_mcontext->__ss.__pc
#elif defined(__x86_64__)
#define PC_FROM_UCONTEXT uc_mcontext->__ss.__rip
#else
#error "Unsupported macOS architecture"
#endif
#define PERFTOOLS_DLL_DECL
/* #undef PTHREAD_CREATE_JOINABLE */
#define STDC_HEADERS 1
/* #undef TCMALLOC_ALIGN_8BYTES */
/* #undef TCMALLOC_PAGE_SIZE_SHIFT */
#define VERSION "2.10"

#ifndef __STDC_FORMAT_MACROS
# define __STDC_FORMAT_MACROS 1
#endif

#endif  /* #ifndef GPERFTOOLS_CONFIG_H_ */
EOF
""",
    }),
)

# gperftools/tcmalloc.h - generated from tcmalloc.h.in
genrule(
    name = "gen_tcmalloc_h",
    srcs = ["src/gperftools/tcmalloc.h.in"],
    outs = ["src/gperftools/tcmalloc.h"],
    cmd = select({
        ":linux": """sed \
            -e 's/@TC_VERSION_MAJOR@/2/g' \
            -e 's/@TC_VERSION_MINOR@/10/g' \
            -e 's/"@TC_VERSION_PATCH@"/""/g' \
            -e 's/@TC_VERSION_PATCH@//g' \
            -e 's/@ac_cv_have_struct_mallinfo@/1/g' \
            -e 's/@ac_cv_have_std_align_val_t@/1/g' \
            $< > $@""",
        ":macos": """sed \
            -e 's/@TC_VERSION_MAJOR@/2/g' \
            -e 's/@TC_VERSION_MINOR@/10/g' \
            -e 's/"@TC_VERSION_PATCH@"/""/g' \
            -e 's/@TC_VERSION_PATCH@//g' \
            -e 's/@ac_cv_have_struct_mallinfo@/0/g' \
            -e 's/@ac_cv_have_std_align_val_t@/1/g' \
            $< > $@""",
    }),
)

# =============================================================================
# Header/source file lists
# =============================================================================

_HDR_PUBLIC = [
    "src/gperftools/heap-checker.h",
    "src/gperftools/heap-profiler.h",
    "src/gperftools/malloc_extension.h",
    "src/gperftools/malloc_extension_c.h",
    "src/gperftools/malloc_hook.h",
    "src/gperftools/malloc_hook_c.h",
    "src/gperftools/nallocx.h",
    "src/gperftools/profiler.h",
    "src/gperftools/stacktrace.h",
]

_HDR_COMPAT = [
    "src/google/heap-checker.h",
    "src/google/heap-profiler.h",
    "src/google/malloc_extension.h",
    "src/google/malloc_extension_c.h",
    "src/google/malloc_hook.h",
    "src/google/malloc_hook_c.h",
    "src/google/profiler.h",
    "src/google/stacktrace.h",
    "src/google/tcmalloc.h",
]

_HDR_INTERNAL = [
    "src/addressmap-inl.h",
    "src/base/arm_instruction_set_select.h",
    "src/base/atomicops-internals-arm-generic.h",
    "src/base/atomicops-internals-arm-v6plus.h",
    "src/base/atomicops-internals-gcc.h",
    "src/base/atomicops-internals-linuxppc.h",
    "src/base/atomicops-internals-macosx.h",
    "src/base/atomicops-internals-mips.h",
    "src/base/atomicops-internals-windows.h",
    "src/base/atomicops-internals-x86.h",
    "src/base/atomicops.h",
    "src/base/basictypes.h",
    "src/base/commandlineflags.h",
    "src/base/dynamic_annotations.h",
    "src/base/elf_mem_image.h",
    "src/base/elfcore.h",
    "src/base/googleinit.h",
    "src/base/linux_syscall_support.h",
    "src/base/linuxthreads.h",
    "src/base/logging.h",
    "src/base/low_level_alloc.h",
    "src/base/simple_mutex.h",
    "src/base/spinlock.h",
    "src/base/spinlock_internal.h",
    "src/base/spinlock_linux-inl.h",
    "src/base/spinlock_posix-inl.h",
    "src/base/spinlock_win32-inl.h",
    "src/base/stl_allocator.h",
    "src/base/sysinfo.h",
    "src/base/thread_annotations.h",
    "src/base/thread_lister.h",
    "src/base/vdso_support.h",
    "src/central_freelist.h",
    "src/common.h",
    "src/emergency_malloc.h",
    "src/getenv_safe.h",
    "src/getpc.h",
    "src/heap-profile-stats.h",
    "src/heap-profile-table.h",
    "src/internal_logging.h",
    "src/libc_override.h",
    "src/libc_override_gcc_and_weak.h",
    "src/libc_override_glibc.h",
    "src/libc_override_osx.h",
    "src/libc_override_redefine.h",
    "src/linked_list.h",
    "src/malloc_hook-inl.h",
    "src/malloc_hook_mmap_freebsd.h",
    "src/malloc_hook_mmap_linux.h",
    "src/maybe_emergency_malloc.h",
    "src/maybe_threads.h",
    "src/memory_region_map.h",
    "src/packed-cache-inl.h",
    "src/page_heap.h",
    "src/page_heap_allocator.h",
    "src/pagemap.h",
    "src/profile-handler.h",
    "src/profiledata.h",
    "src/raw_printer.h",
    "src/sampler.h",
    "src/span.h",
    "src/stack_trace_table.h",
    "src/stacktrace_arm-inl.h",
    "src/stacktrace_generic-inl.h",
    "src/stacktrace_generic_fp-inl.h",
    "src/stacktrace_impl_setup-inl.h",
    "src/stacktrace_instrument-inl.h",
    "src/stacktrace_libgcc-inl.h",
    "src/stacktrace_libunwind-inl.h",
    "src/stacktrace_powerpc-darwin-inl.h",
    "src/stacktrace_powerpc-inl.h",
    "src/stacktrace_powerpc-linux-inl.h",
    "src/stacktrace_win32-inl.h",
    "src/stacktrace_x86-inl.h",
    "src/static_vars.h",
    "src/symbolize.h",
    "src/system-alloc.h",
    "src/tcmalloc.h",
    "src/tcmalloc_guard.h",
    "src/thread_cache.h",
]

# Sources for the base/spinlock internal library
_SRC_BASE = [
    "src/base/logging.cc",
    "src/base/dynamic_annotations.c",
    "src/base/sysinfo.cc",
    "src/base/spinlock.cc",
    "src/base/spinlock_internal.cc",
    "src/base/atomicops-internals-x86.cc",
]

# Sources for stacktrace
_SRC_STACKTRACE = [
    "src/stacktrace.cc",
    "src/base/elf_mem_image.cc",
    "src/base/vdso_support.cc",
]

# tcmalloc_minimal_internal sources (core allocator)
_SRC_TCMALLOC_INTERNAL = [
    "src/common.cc",
    "src/internal_logging.cc",
    "src/system-alloc.cc",
    "src/memfs_malloc.cc",
    "src/central_freelist.cc",
    "src/page_heap.cc",
    "src/sampler.cc",
    "src/span.cc",
    "src/stack_trace_table.cc",
    "src/static_vars.cc",
    "src/symbolize.cc",
    "src/thread_cache.cc",
    "src/malloc_hook.cc",
    "src/malloc_extension.cc",
    "src/maybe_threads.cc",
]

# Additional sources for full tcmalloc (heap profiler + memory region map)
_SRC_TCMALLOC_EXTRA = [
    "src/base/low_level_alloc.cc",
    "src/heap-profile-table.cc",
    "src/heap-profiler.cc",
    "src/raw_printer.cc",
    "src/memory_region_map.cc",
    "src/emergency_malloc.cc",
    "src/emergency_malloc_for_stacktrace.cc",
]

# The main tcmalloc entry point
_SRC_TCMALLOC = [
    "src/tcmalloc.cc",
]

# Heap checker sources (Linux only)
_SRC_HEAP_CHECKER = [
    "src/base/thread_lister.c",
    "src/base/linuxthreads.cc",
    "src/heap-checker.cc",
    "src/heap-checker-bcad.cc",
]

# CPU profiler sources
_SRC_PROFILER = [
    "src/profiler.cc",
    "src/profile-handler.cc",
    "src/profiledata.cc",
]

# =============================================================================
# Common compilation settings
# =============================================================================

_COPTS = [
    "-DHAVE_CONFIG_H",
    "-DNDEBUG",
    "-DNO_FRAME_POINTER",
    "-fno-omit-frame-pointer",
    "-Wno-unused-result",
    "-Wno-deprecated-declarations",
    "-Wno-sign-compare",
    "-Wno-unused-function",
    "-Wno-unused-variable",
    "-Wno-char-subscripts",
]

_COPTS_LINUX = [
    "-DENABLE_EMERGENCY_MALLOC",
]

_COPTS_MACOS = [
    "-DNO_HEAP_CHECK",
]

_LINKOPTS_LINUX = [
    "-lpthread",
]

_LINKOPTS_MACOS = [
    "-lpthread",
]

# =============================================================================
# Library targets
# =============================================================================

cc_library(
    name = "tcmalloc",
    srcs = _SRC_BASE + _SRC_STACKTRACE + _SRC_TCMALLOC_INTERNAL +
           _SRC_TCMALLOC_EXTRA + _SRC_TCMALLOC + _HDR_INTERNAL +
           [":gen_config_h", ":gen_tcmalloc_h"] + select({
        ":linux": _SRC_HEAP_CHECKER,
        ":macos": ["src/fake_stacktrace_scope.cc"],
    }),
    hdrs = _HDR_PUBLIC + _HDR_COMPAT + [":gen_tcmalloc_h"],
    copts = _COPTS + select({
        ":linux": _COPTS_LINUX,
        ":macos": _COPTS_MACOS,
    }),
    includes = ["src"],
    linkopts = select({
        ":linux": _LINKOPTS_LINUX,
        ":macos": _LINKOPTS_MACOS,
    }),
    visibility = ["//visibility:public"],
)

cc_library(
    name = "profiler",
    srcs = _SRC_BASE + _SRC_STACKTRACE + _SRC_PROFILER + _HDR_INTERNAL +
           [":gen_config_h", ":gen_tcmalloc_h"] +
           ["src/fake_stacktrace_scope.cc"],
    hdrs = _HDR_PUBLIC + _HDR_COMPAT + [":gen_tcmalloc_h"],
    copts = _COPTS + select({
        ":linux": _COPTS_LINUX,
        ":macos": _COPTS_MACOS,
    }),
    includes = ["src"],
    linkopts = select({
        ":linux": _LINKOPTS_LINUX,
        ":macos": _LINKOPTS_MACOS,
    }),
    visibility = ["//visibility:public"],
)

# Aggregate target matching original configure_make output
cc_library(
    name = "gperftools",
    visibility = ["//visibility:public"],
    deps = [
        ":profiler",
        ":tcmalloc",
    ],
)
