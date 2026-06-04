#pragma once
#include <iosfwd>
#include <memory>
#include <functional>
namespace Aws {
using IOStream = std::iostream;
using IStream = std::istream;
using OStream = std::ostream;
using IOStreamFactory = std::function<std::shared_ptr<IOStream>()>;
}
