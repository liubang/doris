#pragma once
#include <string>
namespace Aws { namespace Client {
template <typename E> class AWSError {
public:
    AWSError() = default;
    AWSError(E errorType, bool retryable) : m_errorType(errorType), m_retryable(retryable) {}
    E GetErrorType() const { return m_errorType; }
    const std::string& GetMessage() const { return m_message; }
    bool ShouldRetry() const { return m_retryable; }
    const std::string& GetExceptionName() const { return m_exceptionName; }
private:
    E m_errorType{};
    std::string m_message;
    std::string m_exceptionName;
    bool m_retryable = false;
};
}}
