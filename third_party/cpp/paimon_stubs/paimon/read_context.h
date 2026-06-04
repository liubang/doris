#pragma once
#include <string>
#include <memory>

namespace paimon {

class ReadContext {
public:
    virtual ~ReadContext() = default;
};

} // namespace paimon
