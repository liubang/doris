# RocksDB 5.14.2 - Embedded key-value store
# 手写 cc_library 版（替代原 rules_foreign_cc cmake）
#
# 背景：
#   RocksDB 是 Facebook 的高性能嵌入式 KV 存储引擎，Doris 用于本地元数据存储。
#   CMake 构建主要做：
#   1. 特性检测（SSE4.2, fallocate, sync_file_range 等）并设置宏定义
#   2. 生成 build_version.cc
#   3. 编译 ~220 个 .cc 文件为 librocksdb.a
#
# 本方案：
#   1. genrule 生成 build_version.cc
#   2. 平台特定的宏定义通过 select() 实现
#   3. crc32c.cc 在 x86_64 上用 -msse4.2 -mpclmul 单独编译
#   4. 所有压缩库（snappy/zlib/lz4/zstd）作为 deps

load("@rules_cc//cc:defs.bzl", "cc_library")

package(default_visibility = ["//visibility:public"])

# =============================================================================
# Step 1: 生成 build_version.cc
# =============================================================================

genrule(
    name = "gen_build_version_cc",
    outs = ["util/build_version.cc"],
    cmd = """
cat > $@ << 'EOF'
#include "util/build_version.h"
const char* rocksdb_build_git_sha = "rocksdb_build_git_sha:bazel_build";
const char* rocksdb_build_git_date = "rocksdb_build_git_date:2024/01/01 00:00:00";
const char* rocksdb_build_compile_date = __DATE__;
EOF
""",
)

# =============================================================================
# Step 2: 平台特定定义
# =============================================================================

# 公共定义（传播给下游依赖者，公共头文件 port/port.h 需要这些）
_PUBLIC_DEFINES = [
    "ROCKSDB_PLATFORM_POSIX",
    "ROCKSDB_LIB_IO_POSIX",
    "ROCKSDB_SUPPORT_THREAD_LOCAL",
]

# 私有定义（仅 RocksDB 内部实现需要，不传播）
_PRIVATE_DEFINES = [
    "SNAPPY",
    "ZLIB",
    "LZ4",
    "ZSTD",
]

# Linux x86_64 特有的定义
_LINUX_X86_DEFINES = [
    "OS_LINUX",
    "HAVE_SSE42",
    "HAVE_PCLMUL",
    "ROCKSDB_FALLOCATE_PRESENT",
    "ROCKSDB_RANGESYNC_PRESENT",
    "ROCKSDB_PTHREAD_ADAPTIVE_MUTEX",
    "ROCKSDB_MALLOC_USABLE_SIZE",
    "ROCKSDB_SCHED_GETCPU_PRESENT",
]

# macOS 特有的定义
_MACOS_DEFINES = [
    "OS_MACOSX",
]

# =============================================================================
# Step 3: 源文件列表
# =============================================================================

_SOURCES = [
    # cache/
    "cache/clock_cache.cc",
    "cache/lru_cache.cc",
    "cache/sharded_cache.cc",
    # db/
    "db/builder.cc",
    "db/c.cc",
    "db/column_family.cc",
    "db/compacted_db_impl.cc",
    "db/compaction.cc",
    "db/compaction_iterator.cc",
    "db/compaction_job.cc",
    "db/compaction_picker.cc",
    "db/compaction_picker_universal.cc",
    "db/convenience.cc",
    "db/db_filesnapshot.cc",
    "db/db_impl.cc",
    "db/db_impl_write.cc",
    "db/db_impl_compaction_flush.cc",
    "db/db_impl_files.cc",
    "db/db_impl_open.cc",
    "db/db_impl_debug.cc",
    "db/db_impl_experimental.cc",
    "db/db_impl_readonly.cc",
    "db/db_info_dumper.cc",
    "db/db_iter.cc",
    "db/dbformat.cc",
    "db/event_helpers.cc",
    "db/experimental.cc",
    "db/external_sst_file_ingestion_job.cc",
    "db/file_indexer.cc",
    "db/flush_job.cc",
    "db/flush_scheduler.cc",
    "db/forward_iterator.cc",
    "db/internal_stats.cc",
    "db/logs_with_prep_tracker.cc",
    "db/log_reader.cc",
    "db/log_writer.cc",
    "db/malloc_stats.cc",
    "db/managed_iterator.cc",
    "db/memtable.cc",
    "db/memtable_list.cc",
    "db/merge_helper.cc",
    "db/merge_operator.cc",
    "db/range_del_aggregator.cc",
    "db/repair.cc",
    "db/snapshot_impl.cc",
    "db/table_cache.cc",
    "db/table_properties_collector.cc",
    "db/transaction_log_impl.cc",
    "db/version_builder.cc",
    "db/version_edit.cc",
    "db/version_set.cc",
    "db/wal_manager.cc",
    "db/write_batch.cc",
    "db/write_batch_base.cc",
    "db/write_controller.cc",
    "db/write_thread.cc",
    # env/
    "env/env.cc",
    "env/env_chroot.cc",
    "env/env_encryption.cc",
    # env_hdfs.cc excluded: requires HDFS headers (hdfs/env_hdfs.h) not available
    "env/mock_env.cc",
    # memtable/
    "memtable/alloc_tracker.cc",
    "memtable/hash_cuckoo_rep.cc",
    "memtable/hash_linklist_rep.cc",
    "memtable/hash_skiplist_rep.cc",
    "memtable/skiplistrep.cc",
    "memtable/vectorrep.cc",
    "memtable/write_buffer_manager.cc",
    # monitoring/
    "monitoring/histogram.cc",
    "monitoring/histogram_windowing.cc",
    "monitoring/instrumented_mutex.cc",
    "monitoring/iostats_context.cc",
    "monitoring/perf_context.cc",
    "monitoring/perf_level.cc",
    "monitoring/statistics.cc",
    "monitoring/thread_status_impl.cc",
    "monitoring/thread_status_updater.cc",
    "monitoring/thread_status_util.cc",
    "monitoring/thread_status_util_debug.cc",
    # options/
    "options/cf_options.cc",
    "options/db_options.cc",
    "options/options.cc",
    "options/options_helper.cc",
    "options/options_parser.cc",
    "options/options_sanity_check.cc",
    # port/
    "port/stack_trace.cc",
    # table/
    "table/adaptive_table_factory.cc",
    "table/block.cc",
    "table/block_based_filter_block.cc",
    "table/block_based_table_builder.cc",
    "table/block_based_table_factory.cc",
    "table/block_based_table_reader.cc",
    "table/block_builder.cc",
    "table/block_fetcher.cc",
    "table/block_prefix_index.cc",
    "table/bloom_block.cc",
    "table/cuckoo_table_builder.cc",
    "table/cuckoo_table_factory.cc",
    "table/cuckoo_table_reader.cc",
    "table/flush_block_policy.cc",
    "table/format.cc",
    "table/full_filter_block.cc",
    "table/get_context.cc",
    "table/index_builder.cc",
    "table/iterator.cc",
    "table/merging_iterator.cc",
    "table/meta_blocks.cc",
    "table/partitioned_filter_block.cc",
    "table/persistent_cache_helper.cc",
    "table/plain_table_builder.cc",
    "table/plain_table_factory.cc",
    "table/plain_table_index.cc",
    "table/plain_table_key_coding.cc",
    "table/plain_table_reader.cc",
    "table/sst_file_writer.cc",
    "table/table_properties.cc",
    "table/two_level_iterator.cc",
    # tools/
    "tools/db_bench_tool.cc",
    "tools/dump/db_dump_tool.cc",
    "tools/ldb_cmd.cc",
    "tools/ldb_tool.cc",
    "tools/sst_dump_tool.cc",
    # util/ (except crc32c.cc which needs special copts)
    "util/arena.cc",
    "util/auto_roll_logger.cc",
    "util/bloom.cc",
    "util/coding.cc",
    "util/compaction_job_stats_impl.cc",
    "util/comparator.cc",
    "util/concurrent_arena.cc",
    "util/delete_scheduler.cc",
    "util/dynamic_bloom.cc",
    "util/event_logger.cc",
    "util/file_reader_writer.cc",
    "util/file_util.cc",
    "util/filename.cc",
    "util/filter_policy.cc",
    "util/hash.cc",
    "util/log_buffer.cc",
    "util/murmurhash.cc",
    "util/random.cc",
    "util/rate_limiter.cc",
    "util/slice.cc",
    "util/sst_file_manager_impl.cc",
    "util/status.cc",
    "util/status_message.cc",
    "util/string_util.cc",
    "util/sync_point.cc",
    "util/sync_point_impl.cc",
    "util/testutil.cc",
    "util/thread_local.cc",
    "util/threadpool_imp.cc",
    "util/transaction_test_util.cc",
    "util/xxhash.cc",
    # utilities/
    "utilities/backupable/backupable_db.cc",
    "utilities/blob_db/blob_compaction_filter.cc",
    "utilities/blob_db/blob_db.cc",
    "utilities/blob_db/blob_db_impl.cc",
    "utilities/blob_db/blob_dump_tool.cc",
    "utilities/blob_db/blob_file.cc",
    "utilities/blob_db/blob_log_reader.cc",
    "utilities/blob_db/blob_log_writer.cc",
    "utilities/blob_db/blob_log_format.cc",
    "utilities/blob_db/ttl_extractor.cc",
    "utilities/cassandra/cassandra_compaction_filter.cc",
    "utilities/cassandra/format.cc",
    "utilities/cassandra/merge_operator.cc",
    "utilities/checkpoint/checkpoint_impl.cc",
    "utilities/col_buf_decoder.cc",
    "utilities/col_buf_encoder.cc",
    "utilities/column_aware_encoding_util.cc",
    "utilities/compaction_filters/remove_emptyvalue_compactionfilter.cc",
    "utilities/date_tiered/date_tiered_db_impl.cc",
    "utilities/debug.cc",
    "utilities/document/document_db.cc",
    "utilities/document/json_document.cc",
    "utilities/document/json_document_builder.cc",
    "utilities/env_mirror.cc",
    "utilities/env_timed.cc",
    "utilities/geodb/geodb_impl.cc",
    "utilities/leveldb_options/leveldb_options.cc",
    "utilities/lua/rocks_lua_compaction_filter.cc",
    "utilities/memory/memory_util.cc",
    "utilities/merge_operators/bytesxor.cc",
    "utilities/merge_operators/max.cc",
    "utilities/merge_operators/put.cc",
    "utilities/merge_operators/string_append/stringappend.cc",
    "utilities/merge_operators/string_append/stringappend2.cc",
    "utilities/merge_operators/uint64add.cc",
    "utilities/option_change_migration/option_change_migration.cc",
    "utilities/options/options_util.cc",
    "utilities/persistent_cache/block_cache_tier.cc",
    "utilities/persistent_cache/block_cache_tier_file.cc",
    "utilities/persistent_cache/block_cache_tier_metadata.cc",
    "utilities/persistent_cache/persistent_cache_tier.cc",
    "utilities/persistent_cache/volatile_tier_impl.cc",
    "utilities/redis/redis_lists.cc",
    "utilities/simulator_cache/sim_cache.cc",
    "utilities/spatialdb/spatial_db.cc",
    "utilities/table_properties_collectors/compact_on_deletion_collector.cc",
    "utilities/transactions/optimistic_transaction_db_impl.cc",
    "utilities/transactions/optimistic_transaction.cc",
    "utilities/transactions/pessimistic_transaction.cc",
    "utilities/transactions/pessimistic_transaction_db.cc",
    "utilities/transactions/snapshot_checker.cc",
    "utilities/transactions/transaction_base.cc",
    "utilities/transactions/transaction_db_mutex_impl.cc",
    "utilities/transactions/transaction_lock_mgr.cc",
    "utilities/transactions/transaction_util.cc",
    "utilities/transactions/write_prepared_txn.cc",
    "utilities/transactions/write_prepared_txn_db.cc",
    "utilities/ttl/db_ttl_impl.cc",
    "utilities/write_batch_with_index/write_batch_with_index.cc",
    "utilities/write_batch_with_index/write_batch_with_index_internal.cc",
]

# POSIX 平台特有源文件
_POSIX_SOURCES = [
    "port/port_posix.cc",
    "env/env_posix.cc",
    "env/io_posix.cc",
]

# =============================================================================
# Step 4: 公共头文件库（使用 strip_include_prefix 避免包根目录泄漏）
# =============================================================================
#
# 关键设计：使用 strip_include_prefix 后，Bazel 会为 hdrs 创建
# _virtual_includes 符号链接目录，下游的 -isystem 指向该目录，
# 而不是直接指向 package root。这防止了 RocksDB 内部头文件
#（如 util/coding.h）与 Doris 同名头文件冲突。

cc_library(
    name = "rocksdb_headers",
    hdrs = glob(["include/rocksdb/**/*.h"]),
    strip_include_prefix = "include",
    visibility = ["//visibility:public"],
)

# =============================================================================
# Step 5: crc32c 需要 SSE4.2 指令集（x86_64 only）
# =============================================================================

cc_library(
    name = "rocksdb_crc32c",
    srcs = ["util/crc32c.cc"] + glob([
        "util/*.h",
        "port/*.h",
        "include/rocksdb/**/*.h",
        "_private/util/*.h",
    ]),
    copts = ["-w", "-std=c++11", "-I$(GENDIR)/external/+cpp_deps+rocksdb", "-Iexternal/+cpp_deps+rocksdb", "-Iexternal/+cpp_deps+rocksdb/include", "-I$(GENDIR)/external/+cpp_deps+rocksdb/include", "-Iexternal/+cpp_deps+rocksdb/_private"] + select({
        "@platforms//cpu:x86_64": ["-msse4.2", "-mpclmul"],
        "//conditions:default": [],
    }),
    defines = _PUBLIC_DEFINES + select({
        "@platforms//os:macos": _MACOS_DEFINES,
        "//conditions:default": _LINUX_X86_DEFINES,
    }),
    local_defines = _PRIVATE_DEFINES,
    visibility = ["//visibility:private"],
    deps = [
        "@zlib",
        "@zstd//:zstd",
        "@lz4//:lz4",
        "@lz4//:lz4_hc",
        "@lz4//:lz4_frame",
        "@snappy",
    ],
)

# =============================================================================
# Step 6: 主库
# =============================================================================

cc_library(
    name = "rocksdb",
    srcs = _SOURCES + _POSIX_SOURCES + [":gen_build_version_cc"] + glob([
        # 内部头文件（编译需要但不对外暴露）
        "cache/*.h",
        "db/*.h",
        "env/*.h",
        "memtable/*.h",
        "monitoring/*.h",
        "options/*.h",
        "port/*.h",
        "table/*.h",
        "tools/*.h",
        "util/*.h",
        "utilities/**/*.h",
        # third-party 内嵌的头文件（fbson 等）
        "third-party/**/*.h",
        # 公共头文件也作为 srcs（内部编译需要，对外暴露通过 rocksdb_headers）
        "include/rocksdb/**/*.h",
        # 移动到 _private/ 的冲突头文件（遯开 -iquote 搜索）
        "_private/util/*.h",
    ]),
    copts = ["-w", "-std=c++11", "-I$(GENDIR)/external/+cpp_deps+rocksdb", "-Iexternal/+cpp_deps+rocksdb", "-Iexternal/+cpp_deps+rocksdb/include", "-I$(GENDIR)/external/+cpp_deps+rocksdb/include", "-Iexternal/+cpp_deps+rocksdb/_private"],
    defines = _PUBLIC_DEFINES + select({
        "@platforms//os:macos": _MACOS_DEFINES,
        "//conditions:default": _LINUX_X86_DEFINES,
    }),
    local_defines = _PRIVATE_DEFINES,
    linkopts = ["-lpthread"],
    visibility = ["//visibility:public"],
    deps = [
        ":rocksdb_crc32c",
        ":rocksdb_headers",
        "@zlib",
        "@zstd//:zstd",
        "@lz4//:lz4",
        "@lz4//:lz4_hc",
        "@lz4//:lz4_frame",
        "@snappy",
    ],
)
