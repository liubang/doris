#pragma once
#include <cstddef>
#include <memory>

namespace paimon {

class MemoryPool {
public:
    virtual ~MemoryPool() = default;
};

} // namespace paimon
