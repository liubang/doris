#pragma once
#include <memory>

namespace paimon {

class BatchReader {
public:
    virtual ~BatchReader() = default;
};

} // namespace paimon
