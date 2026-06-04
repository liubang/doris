// FAISS stub - minimal header for compilation without real FAISS library
#pragma once
#include "faiss/Index.h"

namespace faiss {
struct IndexFlat : Index {
    explicit IndexFlat(idx_t d = 0, MetricType metric = METRIC_L2) : Index(d, metric) {}
};
struct IndexFlatL2 : IndexFlat {
    explicit IndexFlatL2(idx_t d = 0) : IndexFlat(d, METRIC_L2) {}
};
struct IndexFlatIP : IndexFlat {
    explicit IndexFlatIP(idx_t d = 0) : IndexFlat(d, METRIC_INNER_PRODUCT) {}
};
} // namespace faiss
