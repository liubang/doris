#pragma once
#include "aws/core/utils/logging/LogLevel.h"
#include "aws/core/utils/memory/stl/AWSStringStream.h"
#include <cstdarg>
namespace Aws { namespace Utils { namespace Logging {
class LogSystemInterface {
public:
    virtual ~LogSystemInterface() = default;
    virtual LogLevel GetLogLevel() const = 0;
    virtual void Log(LogLevel logLevel, const char* tag, const char* formatStr, ...) = 0;
    virtual void LogStream(LogLevel logLevel, const char* tag, const Aws::OStringStream& messageStream) = 0;
    virtual void Flush() = 0;
};
}}}
