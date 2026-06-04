#pragma once
#include <string>

namespace paimon {

class Status {
public:
    Status() = default;
    ~Status() = default;
    bool ok() const { return true; }
};

} // namespace paimon
