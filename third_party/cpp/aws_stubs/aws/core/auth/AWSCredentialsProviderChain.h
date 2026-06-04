#pragma once
#include "aws/core/auth/AWSCredentials.h"
#include <vector>
#include <memory>
namespace Aws { namespace Auth {
class AWSCredentialsProviderChain : public AWSCredentialsProvider {
public:
    AWSCredentialsProviderChain() = default;
    ~AWSCredentialsProviderChain() override = default;
    AWSCredentials GetAWSCredentials() override { return AWSCredentials(); }
    void AddProvider(const std::shared_ptr<AWSCredentialsProvider>&) {}
};
}}
