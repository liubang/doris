#pragma once
#include <string>
#include <memory>
#include "paimon/fs/file_system.h"

namespace paimon {

class FileSystemFactory {
public:
    virtual ~FileSystemFactory() = default;
};

} // namespace paimon
