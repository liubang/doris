#pragma once
#include <string>
#include <memory>
namespace Aws { namespace Auth {
class AWSCredentials {
public:
    AWSCredentials() = default;
    AWSCredentials(const std::string& ak, const std::string& sk, const std::string& token = "")
        : m_ak(ak), m_sk(sk), m_token(token) {}
    const std::string& GetAWSAccessKeyId() const { return m_ak; }
    const std::string& GetAWSSecretKey() const { return m_sk; }
    const std::string& GetSessionToken() const { return m_token; }
    void SetAWSAccessKeyId(const std::string& id) { m_ak = id; }
    void SetAWSSecretKey(const std::string& key) { m_sk = key; }
    void SetSessionToken(const std::string& token) { m_token = token; }
    bool IsEmpty() const { return m_ak.empty() && m_sk.empty(); }
private:
    std::string m_ak, m_sk, m_token;
};
class AWSCredentialsProvider {
public:
    virtual ~AWSCredentialsProvider() = default;
    virtual AWSCredentials GetAWSCredentials() = 0;
};
}}
