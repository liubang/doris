#pragma once
#include <string>
#include <memory>

namespace paimon {

class FileSystem {
public:
    virtual ~FileSystem() = default;
};

} // namespace paimon
