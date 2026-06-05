# libevent 2.1.12 - Event notification library
# Hand-written cc_library BUILD file (replaces rules_foreign_cc cmake)

package(default_visibility = ["//visibility:public"])

# =============================================================================
# Platform detection
# =============================================================================

config_setting(
    name = "linux_x86_64",
    constraint_values = [
        "@platforms//os:linux",
        "@platforms//cpu:x86_64",
    ],
)

config_setting(
    name = "linux_aarch64",
    constraint_values = [
        "@platforms//os:linux",
        "@platforms//cpu:aarch64",
    ],
)

config_setting(
    name = "macos_x86_64",
    constraint_values = [
        "@platforms//os:macos",
        "@platforms//cpu:x86_64",
    ],
)

config_setting(
    name = "macos_arm64",
    constraint_values = [
        "@platforms//os:macos",
        "@platforms//cpu:aarch64",
    ],
)

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

_EVENT_CONFIG_H_COMMON = """
#ifndef EVENT2_EVENT_CONFIG_H_INCLUDED_
#define EVENT2_EVENT_CONFIG_H_INCLUDED_

#define EVENT__NUMERIC_VERSION 0x02010c00
#define EVENT__PACKAGE_VERSION "2.1.12"
#define EVENT__VERSION_MAJOR 2
#define EVENT__VERSION_MINOR 1
#define EVENT__VERSION_PATCH 12
#define EVENT__VERSION "2.1.12-stable"
#define EVENT__PACKAGE "libevent"
#define EVENT__PACKAGE_BUGREPORT ""
#define EVENT__PACKAGE_NAME ""
#define EVENT__PACKAGE_STRING ""
#define EVENT__PACKAGE_TARNAME ""

/* #undef EVENT__DISABLE_DEBUG_MODE */
/* #undef EVENT__DISABLE_MM_REPLACEMENT */
/* #undef EVENT__DISABLE_THREAD_SUPPORT */

#define EVENT__HAVE_ACCEPT4 1
#define EVENT__HAVE_CLOCK_GETTIME 1
#define EVENT__HAVE_FCNTL 1
#define EVENT__HAVE_FCNTL_H 1
#define EVENT__HAVE_FD_MASK 1
#define EVENT__HAVE_GETADDRINFO 1
#define EVENT__HAVE_GETEGID 1
#define EVENT__HAVE_GETEUID 1
#define EVENT__HAVE_GETIFADDRS 1
#define EVENT__HAVE_GETNAMEINFO 1
#define EVENT__HAVE_GETPROTOBYNUMBER 1
#define EVENT__HAVE_GETSERVBYNAME 1
#define EVENT__HAVE_GETTIMEOFDAY 1
#define EVENT__HAVE_IFADDRS_H 1
#define EVENT__HAVE_INET_NTOP 1
#define EVENT__HAVE_INET_PTON 1
#define EVENT__HAVE_INTTYPES_H 1
#define EVENT__HAVE_MMAP 1
#define EVENT__HAVE_NANOSLEEP 1
#define EVENT__HAVE_NETDB_H 1
#define EVENT__HAVE_NETINET_IN_H 1
#define EVENT__HAVE_NETINET_TCP_H 1
#define EVENT__HAVE_OPENSSL 1
#define EVENT__HAVE_PIPE 1
#define EVENT__HAVE_PIPE2 1
#define EVENT__HAVE_POLL 1
#define EVENT__HAVE_POLL_H 1
#define EVENT__HAVE_PTHREADS 1
#define EVENT__HAVE_PUTENV 1
#define EVENT__HAVE_SA_FAMILY_T 1
#define EVENT__HAVE_SELECT 1
#define EVENT__HAVE_SETENV 1
#define EVENT__HAVE_SETFD 1
#define EVENT__HAVE_SETRLIMIT 1
#define EVENT__HAVE_SIGACTION 1
#define EVENT__HAVE_SIGNAL 1
#define EVENT__HAVE_STDARG_H 1
#define EVENT__HAVE_STDDEF_H 1
#define EVENT__HAVE_STDINT_H 1
#define EVENT__HAVE_STDLIB_H 1
#define EVENT__HAVE_STRING_H 1
#define EVENT__HAVE_STRSEP 1
#define EVENT__HAVE_STRTOK_R 1
#define EVENT__HAVE_STRTOLL 1
#define EVENT__HAVE_STRUCT_ADDRINFO 1
#define EVENT__HAVE_STRUCT_IN6_ADDR 1
#define EVENT__HAVE_STRUCT_IN6_ADDR_S6_ADDR16 1
#define EVENT__HAVE_STRUCT_IN6_ADDR_S6_ADDR32 1
#define EVENT__HAVE_STRUCT_SOCKADDR_IN6 1
#define EVENT__HAVE_STRUCT_SOCKADDR_STORAGE 1
#define EVENT__HAVE_STRUCT_SOCKADDR_STORAGE_SS_FAMILY 1
#define EVENT__HAVE_STRUCT_SOCKADDR_UN 1
#define EVENT__HAVE_STRUCT_LINGER 1
#define EVENT__HAVE_SYS_IOCTL_H 1
#define EVENT__HAVE_SYS_MMAN_H 1
#define EVENT__HAVE_SYS_PARAM_H 1
#define EVENT__HAVE_SYS_QUEUE_H 1
#define EVENT__HAVE_SYS_RESOURCE_H 1
#define EVENT__HAVE_SYS_SELECT_H 1
#define EVENT__HAVE_SYS_SOCKET_H 1
#define EVENT__HAVE_SYS_STAT_H 1
#define EVENT__HAVE_SYS_TIME_H 1
#define EVENT__HAVE_SYS_TYPES_H 1
#define EVENT__HAVE_SYS_UIO_H 1
#define EVENT__HAVE_SYS_UN_H 1
#define EVENT__HAVE_SYS_WAIT_H 1
#define EVENT__HAVE_TAILQFOREACH 1
#define EVENT__HAVE_TIMERADD 1
#define EVENT__HAVE_TIMERCLEAR 1
#define EVENT__HAVE_TIMERCMP 1
#define EVENT__HAVE_TIMERISSET 1
#define EVENT__HAVE_UINT8_T 1
#define EVENT__HAVE_UINT16_T 1
#define EVENT__HAVE_UINT32_T 1
#define EVENT__HAVE_UINT64_T 1
#define EVENT__HAVE_UINTPTR_T 1
#define EVENT__HAVE_UMASK 1
#define EVENT__HAVE_UNISTD_H 1
#define EVENT__HAVE_UNSETENV 1
#define EVENT__HAVE_USLEEP 1
#define EVENT__HAVE_VASPRINTF 1
#define EVENT__HAVE___func__ 1
#define EVENT__HAVE___FUNCTION__ 1
#define EVENT__TIME_WITH_SYS_TIME 1
#define EVENT__HAVE_DLFCN_H 1
#define EVENT__HAVE_MEMORY_H 1
#define EVENT__HAVE_ERRNO_H 1

#define EVENT__SIZEOF_INT 4
#define EVENT__SIZEOF_SHORT 2
#define EVENT__SIZEOF_SOCKLEN_T 4

#define EVENT__inline inline
#define EVENT__size_t size_t
#define EVENT__socklen_t socklen_t
#define EVENT__ssize_t ssize_t

#define EVENT__HAVE_DECL_CTL_KERN 0
#define EVENT__HAVE_DECL_KERN_ARND 0
"""

_EVENT_CONFIG_H_LINUX = """
/* Linux-specific */
#define EVENT__HAVE_EPOLL 1
#define EVENT__HAVE_EPOLL_CREATE1 1
#define EVENT__HAVE_EPOLL_CTL 1
#define EVENT__HAVE_EVENTFD 1
#define EVENT__HAVE_GETRANDOM 1
#define EVENT__HAVE_GETHOSTBYNAME_R 1
#define EVENT__HAVE_GETHOSTBYNAME_R_6_ARG 1
#define EVENT__HAVE_SENDFILE 1
#define EVENT__HAVE_SPLICE 1
#define EVENT__HAVE_TIMERFD_CREATE 1
#define EVENT__HAVE_SYS_EPOLL_H 1
#define EVENT__HAVE_SYS_EVENTFD_H 1
#define EVENT__HAVE_SYS_SENDFILE_H 1
#define EVENT__HAVE_SYS_TIMERFD_H 1
#define EVENT__HAVE_SYS_RANDOM_H 1
#define EVENT__DNS_USE_CPU_CLOCK_FOR_ID 1

/* #undef EVENT__HAVE_KQUEUE */
/* #undef EVENT__HAVE_WORKING_KQUEUE */
/* #undef EVENT__HAVE_ARC4RANDOM */
/* #undef EVENT__HAVE_ARC4RANDOM_BUF */
/* #undef EVENT__HAVE_ARC4RANDOM_ADDRANDOM */
/* #undef EVENT__HAVE_ISSETUGID */
/* #undef EVENT__HAVE_STRLCPY */
/* #undef EVENT__HAVE_MACH_ABSOLUTE_TIME */
/* #undef EVENT__HAVE_MACH_MACH_TIME_H */
/* #undef EVENT__HAVE_MACH_MACH_H */
/* #undef EVENT__HAVE_SYS_EVENT_H */
/* #undef EVENT__HAVE_SYS_SYSCTL_H */
/* #undef EVENT__HAVE_NETINET_IN6_H */

#define EVENT__SIZEOF_LONG 8
#define EVENT__SIZEOF_LONG_LONG 8
#define EVENT__SIZEOF_OFF_T 8
#define EVENT__SIZEOF_PTHREAD_T 8
#define EVENT__SIZEOF_SIZE_T 8
#define EVENT__SIZEOF_SSIZE_T 8
#define EVENT__SIZEOF_VOID_P 8

#endif /* EVENT2_EVENT_CONFIG_H_INCLUDED_ */
"""

_EVENT_CONFIG_H_MACOS = """
/* macOS-specific */
#define EVENT__HAVE_KQUEUE 1
#define EVENT__HAVE_WORKING_KQUEUE 1
#define EVENT__HAVE_ARC4RANDOM 1
#define EVENT__HAVE_ARC4RANDOM_BUF 1
/* #undef EVENT__HAVE_ARC4RANDOM_ADDRANDOM */
#define EVENT__HAVE_ISSETUGID 1
#define EVENT__HAVE_STRLCPY 1
#define EVENT__HAVE_MACH_ABSOLUTE_TIME 1
#define EVENT__HAVE_MACH_MACH_TIME_H 1
#define EVENT__HAVE_MACH_MACH_H 1
#define EVENT__HAVE_SYS_EVENT_H 1
#define EVENT__HAVE_SYS_SYSCTL_H 1
/* #undef EVENT__HAVE_NETINET_IN6_H */
#define EVENT__DNS_USE_CPU_CLOCK_FOR_ID 1

/* #undef EVENT__HAVE_EPOLL */
/* #undef EVENT__HAVE_EPOLL_CREATE1 */
/* #undef EVENT__HAVE_EPOLL_CTL */
/* #undef EVENT__HAVE_EVENTFD */
/* #undef EVENT__HAVE_GETRANDOM */
/* #undef EVENT__HAVE_GETHOSTBYNAME_R */
/* #undef EVENT__HAVE_SENDFILE */
/* #undef EVENT__HAVE_SPLICE */
/* #undef EVENT__HAVE_TIMERFD_CREATE */
/* #undef EVENT__HAVE_SYS_EPOLL_H */
/* #undef EVENT__HAVE_SYS_EVENTFD_H */
/* #undef EVENT__HAVE_SYS_SENDFILE_H */
/* #undef EVENT__HAVE_SYS_TIMERFD_H */
/* #undef EVENT__HAVE_SYS_RANDOM_H */

/* macOS does not have accept4 or pipe2 */
#undef EVENT__HAVE_ACCEPT4
#undef EVENT__HAVE_PIPE2

/* macOS sockaddr_in6 has sin6_len */
#define EVENT__HAVE_STRUCT_SOCKADDR_IN6_SIN6_LEN 1
#define EVENT__HAVE_STRUCT_SOCKADDR_IN_SIN_LEN 1

#define EVENT__HAVE_DECL_CTL_KERN 1
#define EVENT__HAVE_DECL_KERN_ARND 0

#define EVENT__SIZEOF_LONG 8
#define EVENT__SIZEOF_LONG_LONG 8
#define EVENT__SIZEOF_OFF_T 8
#define EVENT__SIZEOF_PTHREAD_T 8
#define EVENT__SIZEOF_SIZE_T 8
#define EVENT__SIZEOF_SSIZE_T 8
#define EVENT__SIZEOF_VOID_P 8

#endif /* EVENT2_EVENT_CONFIG_H_INCLUDED_ */
"""

genrule(
    name = "gen_event_config_h",
    outs = ["include/event2/event-config.h"],
    cmd = select({
        ":linux": "cat <<'EOF' > $@\n" + _EVENT_CONFIG_H_COMMON + _EVENT_CONFIG_H_LINUX + "\nEOF",
        ":macos": "cat <<'EOF' > $@\n" + _EVENT_CONFIG_H_COMMON + _EVENT_CONFIG_H_MACOS + "\nEOF",
    }),
)

_EVCONFIG_PRIVATE_H = """
#ifndef EVCONFIG_PRIVATE_H_INCLUDED_
#define EVCONFIG_PRIVATE_H_INCLUDED_

#define _GNU_SOURCE 1

#endif
"""

genrule(
    name = "gen_evconfig_private_h",
    outs = ["evconfig-private.h"],
    cmd = "cat <<'EOF' > $@\n" + _EVCONFIG_PRIVATE_H + "\nEOF",
)

# =============================================================================
# Header filegroups
# =============================================================================

_HDR_PRIVATE = [
    "bufferevent-internal.h",
    "changelist-internal.h",
    "defer-internal.h",
    "epolltable-internal.h",
    "evbuffer-internal.h",
    "event-internal.h",
    "evmap-internal.h",
    "evrpc-internal.h",
    "evsignal-internal.h",
    "evthread-internal.h",
    "ht-internal.h",
    "http-internal.h",
    "iocp-internal.h",
    "ipv6-internal.h",
    "kqueue-internal.h",
    "log-internal.h",
    "minheap-internal.h",
    "mm-internal.h",
    "openssl-compat.h",
    "ratelim-internal.h",
    "strlcpy-internal.h",
    "time-internal.h",
    "util-internal.h",
    "compat/sys/queue.h",
]

_HDR_PUBLIC = [
    "include/event2/buffer.h",
    "include/event2/buffer_compat.h",
    "include/event2/bufferevent.h",
    "include/event2/bufferevent_compat.h",
    "include/event2/bufferevent_ssl.h",
    "include/event2/bufferevent_struct.h",
    "include/event2/dns.h",
    "include/event2/dns_compat.h",
    "include/event2/dns_struct.h",
    "include/event2/event.h",
    "include/event2/event_compat.h",
    "include/event2/event_struct.h",
    "include/event2/http.h",
    "include/event2/http_compat.h",
    "include/event2/http_struct.h",
    "include/event2/keyvalq_struct.h",
    "include/event2/listener.h",
    "include/event2/rpc.h",
    "include/event2/rpc_compat.h",
    "include/event2/rpc_struct.h",
    "include/event2/tag.h",
    "include/event2/tag_compat.h",
    "include/event2/thread.h",
    "include/event2/util.h",
    "include/event2/visibility.h",
]

_HDR_COMPAT = [
    "include/evdns.h",
    "include/evrpc.h",
    "include/event.h",
    "include/evhttp.h",
    "include/evutil.h",
]

# =============================================================================
# Source file lists
# =============================================================================

_SRC_CORE = [
    "buffer.c",
    "bufferevent.c",
    "bufferevent_filter.c",
    "bufferevent_pair.c",
    "bufferevent_ratelim.c",
    "bufferevent_sock.c",
    "event.c",
    "evmap.c",
    "evthread.c",
    "evutil.c",
    "evutil_rand.c",
    "evutil_time.c",
    "listener.c",
    "log.c",
    "signal.c",
    "strlcpy.c",
]

_SRC_CORE_LINUX = [
    "epoll.c",
    "poll.c",
    "select.c",
]

_SRC_CORE_MACOS = [
    "kqueue.c",
    "poll.c",
    "select.c",
]

_SRC_EXTRA = [
    "evdns.c",
    "event_tagging.c",
    "evrpc.c",
    "http.c",
]

_SRC_OPENSSL = [
    "bufferevent_openssl.c",
]

_SRC_PTHREADS = [
    "evthread_pthread.c",
]

# =============================================================================
# Common compilation settings
# =============================================================================

_COPTS = [
    "-DHAVE_CONFIG_H",
    "-D_GNU_SOURCE",
    "-std=c11",
    "-Wno-unused-function",
    "-Wno-unused-variable",
    "-Wno-deprecated-declarations",
]

_INCLUDES = [
    ".",
    "compat",
    "include",
]

# =============================================================================
# Library targets
# =============================================================================

cc_library(
    name = "event_core",
    srcs = _SRC_CORE + _HDR_PRIVATE + [":gen_evconfig_private_h"] + select({
        ":linux": _SRC_CORE_LINUX,
        ":macos": _SRC_CORE_MACOS,
    }),
    hdrs = _HDR_PUBLIC + _HDR_COMPAT + [":gen_event_config_h"],
    copts = _COPTS,
    includes = _INCLUDES,
    linkopts = select({
        ":linux": ["-lpthread"],
        ":macos": [],
    }),
    visibility = ["//visibility:public"],
)

cc_library(
    name = "event_extra",
    srcs = _SRC_EXTRA + _HDR_PRIVATE + [":gen_evconfig_private_h"],
    hdrs = _HDR_PUBLIC + _HDR_COMPAT + [":gen_event_config_h"],
    copts = _COPTS,
    includes = _INCLUDES,
    visibility = ["//visibility:public"],
    deps = [":event_core"],
)

cc_library(
    name = "event_openssl",
    srcs = _SRC_OPENSSL + _HDR_PRIVATE + [":gen_evconfig_private_h"],
    hdrs = _HDR_PUBLIC + _HDR_COMPAT + [":gen_event_config_h"],
    copts = _COPTS,
    includes = _INCLUDES,
    visibility = ["//visibility:public"],
    deps = [
        ":event_core",
        "@openssl//:openssl",
    ],
)

cc_library(
    name = "event_pthreads",
    srcs = _SRC_PTHREADS + _HDR_PRIVATE + [":gen_evconfig_private_h"],
    hdrs = _HDR_PUBLIC + _HDR_COMPAT + [":gen_event_config_h"],
    copts = _COPTS,
    includes = _INCLUDES,
    linkopts = ["-lpthread"],
    visibility = ["//visibility:public"],
    deps = [":event_core"],
)

# Aggregate target matching the original cmake output
cc_library(
    name = "libevent",
    visibility = ["//visibility:public"],
    deps = [
        ":event_core",
        ":event_extra",
        ":event_openssl",
        ":event_pthreads",
    ],
)
