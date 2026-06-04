#pragma once
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
