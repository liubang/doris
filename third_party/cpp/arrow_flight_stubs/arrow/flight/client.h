#pragma once

// Minimal stub for arrow::flight types used in remote_doris_reader.h
// The real Arrow Flight SQL library is not yet built in Bazel.

#include <memory>
#include <string>

// arrow::Status is already defined by the real Arrow library (arrow/status.h).
// We only need to provide the flight-specific types here.

namespace arrow {
namespace flight {

class FlightClient {
public:
    virtual ~FlightClient() = default;
};

class FlightStreamReader {
public:
    virtual ~FlightStreamReader() = default;
};

} // namespace flight
} // namespace arrow
