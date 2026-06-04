#pragma once
#include <string>
#include <memory>
#include <vector>
#include "paimon/predicate/literal.h"

namespace paimon {

class PredicateBuilder {
public:
    virtual ~PredicateBuilder() = default;
};

} // namespace paimon
