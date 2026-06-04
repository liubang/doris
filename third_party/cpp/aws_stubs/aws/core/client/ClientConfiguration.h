#pragma once
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
