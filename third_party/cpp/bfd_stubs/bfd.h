// Stub bfd.h for platforms without GNU binutils (e.g., macOS)
// Provides minimal type declarations needed for bfd_parser.h to compile.
#pragma once

// Forward declarations / minimal types
typedef struct bfd bfd;
typedef struct bfd_symbol {
    const char* name;
    unsigned long value;
} bfd_symbol;

// Minimal function stubs (never called on macOS)
static inline void bfd_init(void) {}
