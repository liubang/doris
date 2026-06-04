#pragma once
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
