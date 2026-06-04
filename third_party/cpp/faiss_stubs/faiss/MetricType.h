// FAISS stub - minimal header for compilation without real FAISS library
#pragma once

namespace faiss {

enum MetricType {
    METRIC_INNER_PRODUCT = 0,
    METRIC_L2 = 1,
    METRIC_L1,
    METRIC_Linf,
    METRIC_Lp,
    METRIC_Canberra = 20,
    METRIC_BrayCurtis,
    METRIC_JensenShannon,
    METRIC_Jaccard,
};

} // namespace faiss
