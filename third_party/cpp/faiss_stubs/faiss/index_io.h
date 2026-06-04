// FAISS stub - minimal header for compilation without real FAISS library
#pragma once
#include "faiss/Index.h"
#include "faiss/impl/io.h"

namespace faiss {
inline Index* read_index(IOReader* /*f*/, int /*io_flags*/ = 0) { return nullptr; }
inline void write_index(const Index* /*idx*/, IOWriter* /*f*/) {}
} // namespace faiss
