#pragma once

// Minimal stub for libhdfs (hdfs.h) used by Doris HDFS file system.
// This provides type declarations and function prototypes needed for compilation.
// The real libhdfs is a JNI library from Apache Hadoop.

#include <stdint.h>
#include <stddef.h>
#include <time.h>

#ifdef __cplusplus
extern "C" {
#endif

// Basic types
typedef int32_t tSize;
typedef int64_t tOffset;
typedef uint16_t tPort;
typedef time_t tTime;

typedef enum {
    kObjectKindFile = 'F',
    kObjectKindDirectory = 'D',
} tObjectKind;

// Opaque handle types
struct hdfs_internal;
typedef struct hdfs_internal* hdfsFS;

struct hdfsFile_internal;
typedef struct hdfsFile_internal* hdfsFile;

struct hdfsBuilder;

// File info structure
typedef struct {
    tObjectKind mKind;
    char* mName;
    tTime mLastMod;
    tOffset mSize;
    short mReplication;
    tOffset mBlockSize;
    char* mOwner;
    char* mGroup;
    short mPermissions;
    tTime mLastAccess;
} hdfsFileInfo;

// Read statistics
struct hdfsReadStatistics {
    uint64_t totalBytesRead;
    uint64_t totalLocalBytesRead;
    uint64_t totalShortCircuitBytesRead;
    uint64_t totalZeroCopyBytesRead;
};

// Hedged read metrics
struct hdfsHedgedReadMetrics {
    uint64_t hedgedReadOps;
    uint64_t hedgedReadOpsWin;
    uint64_t hedgedReadOpsInCurThread;
};

// Builder functions
struct hdfsBuilder* hdfsNewBuilder(void);
void hdfsFreeBuilder(struct hdfsBuilder* bld);
void hdfsBuilderSetForceNewInstance(struct hdfsBuilder* bld);
void hdfsBuilderSetNameNode(struct hdfsBuilder* bld, const char* nn);
void hdfsBuilderSetNameNodePort(struct hdfsBuilder* bld, tPort port);
void hdfsBuilderSetUserName(struct hdfsBuilder* bld, const char* userName);
int hdfsBuilderConfSetStr(struct hdfsBuilder* bld, const char* key, const char* val);
void hdfsBuilderSetKerb5Conf(struct hdfsBuilder* bld, const char* krb5Conf);
void hdfsBuilderSetKeyTabFile(struct hdfsBuilder* bld, const char* keyTabFile);
void hdfsBuilderSetPrincipal(struct hdfsBuilder* bld, const char* principal);

// Connection functions
hdfsFS hdfsBuilderConnect(struct hdfsBuilder* bld);
hdfsFS hdfsConnect(const char* nn, tPort port);
hdfsFS hdfsConnectAsUser(const char* nn, tPort port, const char* user);
int hdfsDisconnect(hdfsFS fs);

// File operations
hdfsFile hdfsOpenFile(hdfsFS fs, const char* path, int flags, int bufferSize,
                      short replication, tOffset blocksize);
int hdfsCloseFile(hdfsFS fs, hdfsFile file);
int hdfsExists(hdfsFS fs, const char* path);
int hdfsSeek(hdfsFS fs, hdfsFile file, tOffset desiredPos);
tOffset hdfsTell(hdfsFS fs, hdfsFile file);
tSize hdfsRead(hdfsFS fs, hdfsFile file, void* buffer, tSize length);
tSize hdfsPread(hdfsFS fs, hdfsFile file, tOffset position, void* buffer, tSize length);
tSize hdfsWrite(hdfsFS fs, hdfsFile file, const void* buffer, tSize length);
int hdfsFlush(hdfsFS fs, hdfsFile file);
int hdfsHFlush(hdfsFS fs, hdfsFile file);
int hdfsHSync(hdfsFS fs, hdfsFile file);
int hdfsSync(hdfsFS fs, hdfsFile file);
int hdfsAvailable(hdfsFS fs, hdfsFile file);
int hdfsUnbufferFile(hdfsFile file);

// Directory operations
int hdfsCreateDirectory(hdfsFS fs, const char* path);
int hdfsDelete(hdfsFS fs, const char* path, int recursive);
int hdfsRename(hdfsFS fs, const char* oldPath, const char* newPath);
hdfsFileInfo* hdfsListDirectory(hdfsFS fs, const char* path, int* numEntries);
hdfsFileInfo* hdfsGetPathInfo(hdfsFS fs, const char* path);
void hdfsFreeFileInfo(hdfsFileInfo* hdfsFileInfo, int numEntries);

// Read statistics
int hdfsFileGetReadStatistics(hdfsFile file, struct hdfsReadStatistics** stats);
void hdfsFileFreeReadStatistics(struct hdfsReadStatistics* stats);
void hdfsFileClearReadStatistics(hdfsFile file);
int hdfsGetHedgedReadMetrics(hdfsFS fs, struct hdfsHedgedReadMetrics** metrics);
void hdfsFreeHedgedReadMetrics(struct hdfsHedgedReadMetrics* metrics);

// Error handling
char* hdfsGetLastExceptionRootCause(void);
char* hdfsGetLastExceptionStackTrace(void);

// Misc
int hdfsChmod(hdfsFS fs, const char* path, short mode);
int hdfsChown(hdfsFS fs, const char* path, const char* owner, const char* group);

#ifdef __cplusplus
}
#endif
