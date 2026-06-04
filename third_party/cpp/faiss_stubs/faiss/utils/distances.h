// FAISS stub - minimal header for compilation without real FAISS library
#pragma once
#include <cstddef>
#include <cmath>

namespace faiss {

inline float fvec_L1(const float* x, const float* y, size_t d) {
    float sum = 0;
    for (size_t i = 0; i < d; ++i) sum += std::fabs(x[i] - y[i]);
    return sum;
}

inline float fvec_L2sqr(const float* x, const float* y, size_t d) {
    float sum = 0;
    for (size_t i = 0; i < d; ++i) {
        float diff = x[i] - y[i];
        sum += diff * diff;
    }
    return sum;
}

inline float fvec_inner_product(const float* x, const float* y, size_t d) {
    float sum = 0;
    for (size_t i = 0; i < d; ++i) sum += x[i] * y[i];
    return sum;
}

inline float fvec_norm_L2sqr(const float* x, size_t d) {
    float sum = 0;
    for (size_t i = 0; i < d; ++i) sum += x[i] * x[i];
    return sum;
}

} // namespace faiss
