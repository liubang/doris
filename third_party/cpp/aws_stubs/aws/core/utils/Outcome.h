#pragma once
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
