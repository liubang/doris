// FAISS stub - minimal header for compilation without real FAISS library
#pragma once
#include "faiss/Index.h"

namespace faiss {
struct IndexIVF : Index {
    size_t nlist;
    size_t nprobe;
    explicit IndexIVF() : nlist(0), nprobe(1) {}
};
} // namespace faiss
