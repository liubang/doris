// FAISS stub - minimal header for compilation without real FAISS library
#pragma once
#include <stdexcept>
#include <string>

namespace faiss {
class FaissException : public std::runtime_error {
public:
    explicit FaissException(const std::string& msg) : std::runtime_error(msg) {}
};
} // namespace faiss
