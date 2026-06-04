#pragma once
namespace Azure { namespace Core { namespace Http { namespace Policies {
class RetryOptions {
public:
    int MaxRetries = 3;
    int RetryDelay = 800;
    int MaxRetryDelay = 60000;
};
}}}}
