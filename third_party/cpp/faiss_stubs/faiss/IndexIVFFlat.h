// FAISS stub - minimal header for compilation without real FAISS library
#pragma once
#include "faiss/IndexIVF.h"

namespace faiss {
struct IndexIVFFlat : IndexIVF {};
} // namespace faiss
