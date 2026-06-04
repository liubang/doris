#pragma once
#include <string>
#include "aws/core/auth/AWSCredentials.h"
#include "aws/core/client/ClientConfiguration.h"
#include "aws/core/utils/logging/LogLevel.h"
namespace Aws {
struct SDKOptions {};
inline void InitAPI(const SDKOptions&) {}
inline void ShutdownAPI(const SDKOptions&) {}
}
