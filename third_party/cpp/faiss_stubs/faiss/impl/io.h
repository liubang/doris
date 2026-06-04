// FAISS stub - minimal header for compilation without real FAISS library
#pragma once
#include <cstdio>
#include <cstddef>

namespace faiss {
struct IOReader {
    virtual ~IOReader() = default;
    virtual size_t operator()(void* ptr, size_t size, size_t nitems) = 0;
};
struct IOWriter {
    virtual ~IOWriter() = default;
    virtual size_t operator()(const void* ptr, size_t size, size_t nitems) = 0;
};
} // namespace faiss
