#pragma once

#include <cstdint>
#include <string>

namespace paimon {

using RowKind = int8_t;

enum class FieldType {
    UNKNOWN = 0,
    BOOLEAN,
    TINYINT,
    SMALLINT,
    INT,
    BIGINT,
    FLOAT,
    DOUBLE,
    DECIMAL,
    CHAR,
    VARCHAR,
    STRING,
    BINARY,
    VARBINARY,
    DATE,
    TIMESTAMP,
    TIMESTAMP_WITH_LOCAL_TIME_ZONE,
    ARRAY,
    MAP,
    ROW,
};

} // namespace paimon
