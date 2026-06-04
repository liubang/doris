#pragma once
#include <variant>
#include <string>

namespace paimon {

template <typename T>
class Result {
public:
    Result() = default;
    ~Result() = default;
};

} // namespace paimon
