#pragma once
#include <string>
#include <memory>
#include <vector>

namespace paimon {

class Literal {
public:
    virtual ~Literal() = default;
};

class Predicate {
public:
    virtual ~Predicate() = default;
};

} // namespace paimon
