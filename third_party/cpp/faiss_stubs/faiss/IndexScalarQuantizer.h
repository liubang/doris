// FAISS stub - minimal header for compilation without real FAISS library
#pragma once
#include "faiss/Index.h"

namespace faiss {
struct IndexScalarQuantizer : Index {};
} // namespace faiss
