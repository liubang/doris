#pragma once
#include "aws/core/client/AWSError.h"
namespace Aws { namespace Client {

enum class CoreErrors {
    INCOMPLETE_SIGNATURE = 0, INTERNAL_FAILURE, INVALID_ACTION,
    NETWORK_CONNECTION, REQUEST_TIMEOUT, UNKNOWN
};

class RetryStrategy {
public:
    virtual ~RetryStrategy() = default;
    virtual bool ShouldRetry(const AWSError<CoreErrors>&, long) const { return false; }
    virtual long CalculateDelayBeforeNextRetry(const AWSError<CoreErrors>&, long) const { return 0; }
};

class DefaultRetryStrategy : public RetryStrategy {
public:
    DefaultRetryStrategy(long maxRetries = 3) : m_maxRetries(maxRetries) {}
    ~DefaultRetryStrategy() override = default;
    bool ShouldRetry(const AWSError<CoreErrors>& error, long attemptedRetries) const override {
        return attemptedRetries < m_maxRetries;
    }
    long CalculateDelayBeforeNextRetry(const AWSError<CoreErrors>&, long attemptedRetries) const override {
        return (1L << attemptedRetries) * 25L;
    }
    long GetMaxRetries() const { return m_maxRetries; }
private:
    long m_maxRetries;
};
}}
