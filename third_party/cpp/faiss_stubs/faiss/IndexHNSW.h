// FAISS stub - minimal header for compilation without real FAISS library
#pragma once
#include "faiss/Index.h"

namespace faiss {
struct IndexHNSW : Index {
    explicit IndexHNSW(int d = 0, int M = 32, MetricType metric = METRIC_L2)
        : Index(d, metric) { (void)M; }
};
} // namespace faiss
