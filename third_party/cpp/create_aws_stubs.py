#!/usr/bin/env python3
"""Create minimal AWS SDK stub headers for Bazel build."""
import os

STUBS_DIR = os.path.join(os.path.dirname(__file__), 'aws_stubs')

FILES = {
    'aws/core/Aws.h': '''#pragma once
#include <string>
namespace Aws {
struct SDKOptions {};
inline void InitAPI(const SDKOptions&) {}
inline void ShutdownAPI(const SDKOptions&) {}
namespace Utils { namespace Logging { enum class LogLevel { Off, Fatal, Error, Warn, Info, Debug, Trace }; } }
}
''',
    'aws/core/client/ClientConfiguration.h': '''#pragma once
#include <string>
namespace Aws { namespace Client {
struct ClientConfiguration {
    std::string region;
    std::string endpointOverride;
    std::string caFile;
    std::string caPath;
    long requestTimeoutMs = 0;
    long connectTimeoutMs = 0;
    int maxConnections = 25;
    bool verifySSL = true;
    std::string proxyHost;
    unsigned proxyPort = 0;
    std::string proxyUserName;
    std::string proxyPassword;
};
}}
''',
    'aws/core/client/AWSError.h': '''#pragma once
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
''',
    'aws/core/auth/AWSCredentials.h': '''#pragma once
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
''',
    'aws/core/auth/AWSAuthSigner.h': '''#pragma once
namespace Aws { namespace Auth {} }
''',
    'aws/core/http/HttpResponse.h': '''#pragma once
namespace Aws { namespace Http {
enum class HttpResponseCode {
    REQUEST_NOT_MADE = -1, OK = 200, CREATED = 201, NO_CONTENT = 204,
    BAD_REQUEST = 400, UNAUTHORIZED = 401, FORBIDDEN = 403, NOT_FOUND = 404,
    INTERNAL_SERVER_ERROR = 500, SERVICE_UNAVAILABLE = 503
};
}}
''',
    'aws/core/utils/Outcome.h': '''#pragma once
#include <utility>
namespace Aws { namespace Utils {
template <typename R, typename E> class Outcome {
public:
    Outcome() : m_success(false) {}
    Outcome(const R& r) : m_result(r), m_success(true) {}
    Outcome(const E& e) : m_error(e), m_success(false) {}
    Outcome(R&& r) : m_result(std::move(r)), m_success(true) {}
    Outcome(E&& e) : m_error(std::move(e)), m_success(false) {}
    bool IsSuccess() const { return m_success; }
    const R& GetResult() const { return m_result; }
    R& GetResult() { return m_result; }
    const E& GetError() const { return m_error; }
private:
    R m_result{}; E m_error{}; bool m_success;
};
}}
''',
    'aws/core/utils/Array.h': '''#pragma once
#include <cstddef>
#include <cstring>
#include <memory>
namespace Aws { namespace Utils {
template <typename T> class Array {
public:
    Array() : m_size(0) {}
    Array(size_t s) : m_size(s), m_data(new T[s]()) {}
    Array(const T* d, size_t s) : m_size(s), m_data(new T[s]) { std::memcpy(m_data.get(), d, s*sizeof(T)); }
    size_t GetLength() const { return m_size; }
    T* GetUnderlyingData() { return m_data.get(); }
    const T* GetUnderlyingData() const { return m_data.get(); }
    T& operator[](size_t i) { return m_data[i]; }
    const T& operator[](size_t i) const { return m_data[i]; }
private:
    size_t m_size; std::unique_ptr<T[]> m_data;
};
using ByteBuffer = Array<unsigned char>;
}}
''',
    'aws/core/utils/HashingUtils.h': '''#pragma once
#include <string>
#include "aws/core/utils/Array.h"
namespace Aws { namespace Utils {
class HashingUtils {
public:
    static ByteBuffer Base64Decode(const std::string&) { return ByteBuffer(); }
    static std::string Base64Encode(const ByteBuffer&) { return ""; }
};
}}
''',
    'aws/core/utils/logging/LogLevel.h': '''#pragma once
namespace Aws { namespace Utils { namespace Logging {
enum class LogLevel { Off, Fatal, Error, Warn, Info, Debug, Trace };
}}}
''',
    'aws/core/utils/logging/LogSystemInterface.h': '''#pragma once
#include "aws/core/utils/logging/LogLevel.h"
namespace Aws { namespace Utils { namespace Logging {
class LogSystemInterface {
public:
    virtual ~LogSystemInterface() = default;
    virtual LogLevel GetLogLevel() const = 0;
    virtual void Flush() = 0;
};
}}}
''',
    'aws/core/utils/memory/stl/AWSAllocator.h': '''#pragma once
#include <memory>
namespace Aws { template <typename T> using Allocator = std::allocator<T>; }
''',
    'aws/core/utils/memory/stl/AWSMap.h': '''#pragma once
#include <map>
namespace Aws { template <typename K, typename V> using Map = std::map<K, V>; }
''',
    'aws/core/utils/memory/stl/AWSStreamFwd.h': '''#pragma once
#include <iosfwd>
#include <memory>
#include <functional>
namespace Aws {
using IOStream = std::iostream;
using IStream = std::istream;
using OStream = std::ostream;
using IOStreamFactory = std::function<std::shared_ptr<IOStream>()>;
}
''',
    'aws/core/utils/memory/stl/AWSString.h': '''#pragma once
#include <string>
namespace Aws { using String = std::string; }
''',
    'aws/core/utils/memory/stl/AWSStringStream.h': '''#pragma once
#include <sstream>
namespace Aws {
using StringStream = std::stringstream;
using IStringStream = std::istringstream;
using OStringStream = std::ostringstream;
}
''',
    'aws/core/utils/memory/stl/AWSVector.h': '''#pragma once
#include <vector>
namespace Aws { template <typename T> using Vector = std::vector<T>; }
''',
    'aws/core/utils/stream/PreallocatedStreamBuf.h': '''#pragma once
#include <streambuf>
namespace Aws { namespace Utils { namespace Stream {
class PreallocatedStreamBuf : public std::streambuf {
public:
    PreallocatedStreamBuf(unsigned char* buf, size_t len) {
        char* b = reinterpret_cast<char*>(buf);
        setg(b, b, b + len);
    }
};
}}}
''',
    'aws/core/utils/threading/Executor.h': '''#pragma once
#include <functional>
namespace Aws { namespace Utils { namespace Threading {
class Executor {
public:
    virtual ~Executor() = default;
    virtual bool SubmitToThread(std::function<void()>&&) = 0;
};
class PooledThreadExecutor : public Executor {
public:
    PooledThreadExecutor(size_t) {}
    bool SubmitToThread(std::function<void()>&&) override { return false; }
};
}}}
''',
    'aws/s3/S3Errors.h': '''#pragma once
namespace Aws { namespace S3 {
enum class S3Errors {
    INCOMPLETE_SIGNATURE = 0, INTERNAL_FAILURE, INVALID_ACTION,
    ACCESS_DENIED, RESOURCE_NOT_FOUND, UNKNOWN,
    BUCKET_ALREADY_EXISTS, BUCKET_ALREADY_OWNED_BY_YOU,
    NO_SUCH_BUCKET, NO_SUCH_KEY, NO_SUCH_UPLOAD,
    NETWORK_CONNECTION, REQUEST_TIMEOUT, SLOW_DOWN, THROTTLING
};
}}
''',
    'aws/s3/S3Client.h': '''#pragma once
#include "aws/core/client/ClientConfiguration.h"
#include "aws/core/auth/AWSCredentials.h"
namespace Aws { namespace S3 {
class S3Client {
public:
    S3Client() = default;
    virtual ~S3Client() = default;
};
}}
''',
}

# S3 model stubs
S3_MODELS = [
    'AbortMultipartUploadRequest', 'AbortMultipartUploadResult',
    'CompleteMultipartUploadRequest', 'CompleteMultipartUploadResult',
    'CompletedMultipartUpload', 'CompletedPart',
    'CopyObjectRequest', 'CopyObjectResult',
    'CreateMultipartUploadRequest', 'CreateMultipartUploadResult',
    'Delete', 'DeleteObjectRequest', 'DeleteObjectResult',
    'DeleteObjectsRequest', 'DeleteObjectsResult', 'Error',
    'GetBucketVersioningRequest', 'GetBucketVersioningResult',
    'GetObjectRequest', 'GetObjectResult',
    'HeadObjectRequest', 'HeadObjectResult',
    'ListObjectVersionsRequest', 'ListObjectVersionsResult',
    'ListObjectsV2Request', 'ListObjectsV2Result',
    'Object', 'ObjectIdentifier', 'ObjectVersion',
    'PutObjectRequest', 'PutObjectResult',
    'UploadPartRequest', 'UploadPartResult',
]

for model in S3_MODELS:
    FILES[f'aws/s3/model/{model}.h'] = f'#pragma once\n// Stub for {model}\n'

def main():
    for path, content in FILES.items():
        full_path = os.path.join(STUBS_DIR, path)
        os.makedirs(os.path.dirname(full_path), exist_ok=True)
        with open(full_path, 'w') as f:
            f.write(content)
    print(f'Created {len(FILES)} stub files in {STUBS_DIR}')

if __name__ == '__main__':
    main()
