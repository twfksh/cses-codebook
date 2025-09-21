# CSES Problem Set Solutions

A collection of solutions to problems from the [CSES Problem Set](https://cses.fi/problemset/) using C++ with a Zig build system for streamlined compilation and execution.

## Overview

This repository contains competitive programming solutions written in C++20 or C++23, with a custom Zig build system that provides pattern matching for easy compilation and execution of specific problems.

## Project Structure

```
cses-problemset/
├── src/                    # C++ source files
│   ├── 1753_string_matching.cpp
│   └── ...
├── build.zig              # Zig build configuration
├── build.zig.zon         # Zig package configuration
├── inputf.in             # Sample input file
└── README.md             # This file
```

## Prerequisites

- [Zig](https://ziglang.org/) (version 0.15.1 or later)
- A C++ compiler (automatically handled by Zig)

## Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd cses-codebook
   ```

2. Make sure you have Zig installed:
   ```bash
   zig version
   ```

## Usage

The build system uses pattern matching to find and compile the correct source file based on a search pattern.

### Basic Usage

```bash
# Run a specific problem by pattern
zig build run -- <pattern>

# Run with input from a file
zig build run -- <pattern> <input_file>
```

### Examples

```bash
# Run the string matching problem
zig build run -- string_matching

# Run with specific input file
zig build run -- string_matching inputf.in

# Run problem 1753
zig build run -- 1753
```

## File Naming Convention

Source files should follow the pattern: `<problem_number>_<problem_name>.cpp`

Examples:
- `1753_string_matching.cpp`
- `1001_weird_algorithm.cpp`
- `1068_weird_algorithm.cpp`

## License

This project is open source. Please check individual problem constraints and CSES terms of use when sharing solutions.

## Resources

- [CSES Problem Set](https://cses.fi/problemset/)
- [Zig Documentation](https://ziglang.org/documentation/)
- [Competitive Programming Handbook](https://cses.fi/book/)
