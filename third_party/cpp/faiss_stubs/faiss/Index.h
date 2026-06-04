// FAISS stub - minimal header for compilation without real FAISS library
#pragma once
#include <cstddef>
#include <cstdint>
#include "faiss/MetricType.h"
#include "faiss/impl/IDSelector.h"
#include "faiss/impl/platform_macros.h"

namespace faiss {

using idx_t = int64_t;

struct Index {
    int d;
    idx_t ntotal;
    MetricType metric_type;
    bool is_trained;

    explicit Index(idx_t d = 0, MetricType metric = METRIC_L2)
        : d(d), ntotal(0), metric_type(metric), is_trained(false) {}
    virtual ~Index() = default;

    virtual void train(idx_t /*n*/, const float* /*x*/) {}
    virtual void add(idx_t /*n*/, const float* /*x*/) {}
    virtual void search(idx_t /*n*/, const float* /*x*/, idx_t /*k*/,
                        float* /*distances*/, idx_t* /*labels*/) const {}
    virtual void reset() {}
};

} // namespace faiss
