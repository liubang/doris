#pragma once
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
