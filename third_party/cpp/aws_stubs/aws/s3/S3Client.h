#pragma once
#include "aws/core/client/ClientConfiguration.h"
#include "aws/core/auth/AWSCredentials.h"
namespace Aws { namespace S3 {
class S3Client {
public:
    S3Client() = default;
    virtual ~S3Client() = default;
};
}}
