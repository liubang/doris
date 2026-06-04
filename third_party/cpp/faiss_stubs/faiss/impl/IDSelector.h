// FAISS stub - minimal header for compilation without real FAISS library
#pragma once
#include <cstdint>
#include "faiss/impl/platform_macros.h"

namespace faiss {
using idx_t = int64_t;
struct IDSelector {
    virtual ~IDSelector() = default;
    virtual bool is_member(idx_t id) const = 0;
};
struct IDSelectorRange : IDSelector {
    idx_t imin, imax;
    IDSelectorRange(idx_t imin, idx_t imax) : imin(imin), imax(imax) {}
    bool is_member(idx_t id) const override { return id >= imin && id < imax; }
};
} // namespace faiss
