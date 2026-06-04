#pragma once
#include <string>
#include "aws/core/utils/Array.h"
namespace Aws { namespace Utils {
class HashingUtils {
public:
    static ByteBuffer Base64Decode(const std::string&) { return ByteBuffer(); }
    static std::string Base64Encode(const ByteBuffer&) { return ""; }
};
}}
