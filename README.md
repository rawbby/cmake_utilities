# CMake Utilities

This repository provides utilities for **automatically detecting and configuring** different target types in a CMake
project based on marker `.cmake` files. It works on Linux and Windows, scanning your source tree for these marker files:

1. **executable.cmake**
2. **header.cmake**
3. **shared.cmake**
4. **static.cmake**
5. **tests.cmake**
6. **extern.cmake**

---

## How It Works

The main script:

1. **Scans** your source tree for these marker `.cmake` files.
2. **Collects** source/header files by looking in specific subdirectories (`src`, `source`, `inc`, `include`).
3. **Creates** corresponding targets (`add_executable`, `add_library`) automatically.
4. **Optionally** creates test executables if `BUILD_TESTING` is turned ON.

**No test framework is used**—tests are simple executables run via CTest.

---

## Marker Files and Scanned Directories

### 1. `executable.cmake`

**Purpose**: Defines a directory containing the source of an **executable**.

**Scanned Directories**:

- `src/`
- `source/`
- `inc/` (headers only)

All `.c`, `.cc`, `.cp`, `.cpp`, `.cxx` files found are added as source files for the resulting executable. Any headers
in `inc/` are also included as part of the target.

---

### 2. `header.cmake`

**Purpose**: Defines a directory containing a **header-only library** (an `INTERFACE` library in CMake).

**Scanned Directories**:

- `include/` (headers only)

Because this creates an INTERFACE library, no source files are compiled; everything in `include/` is installed and
exposed to consumers.

---

### 3. `shared.cmake`

**Purpose**: Defines a directory containing the source of a **shared library**.

**Scanned Directories**:

- `src/`
- `source/`
- `inc/` (headers only)
- `include/` (headers only)

**Export Logic**:

- An **export header** file is automatically generated in `<binary-dir>/<target-name>/include/<target-name>_export.h`.
- The library is compiled with `add_library(<target> SHARED)`.
- An appropriate preprocessor definition (e.g., `MY_LIBRARY_EXPORTS`) is added to support symbol exports on different
  platforms.

---

### 4. `static.cmake`

**Purpose**: Defines a directory containing the source of a **static library**.

**Scanned Directories**:

- `src/`
- `source/`
- `inc/` (headers only)
- `include/` (headers only)

A normal static library is compiled with `add_library(<target> STATIC)`.

---

### 5. `tests.cmake`

**Purpose**: Defines a directory containing **test sources**.

**Behavior**:

- Each `.cpp` (or other source extension) in this folder is built as a **separate test executable**.
- **No test framework** is provided; each test is a simple executable.
- When `BUILD_TESTING=ON`, CTest is enabled, and these executables are registered as tests (via `add_test`).

### 6. `extern.cmake`

**Purpose**: Defines a directory containing only a single script to ensure an **external dependency**.

**Behavior**:

- is included once

---

## Example Structure

```plaintext
my_project/
  .cmake_utilities/
    all.cmake
    ...
  src_shared/
    shared.cmake
    src/
      lib.cpp
    include/
      lib.hpp
  src_static/
    static.cmake
    src/
      lib_impl.cpp
  src_exec/
    executable.cmake
    src/
      main.cpp
  headers_only/
    header.cmake
    include/
      utility.hpp
  tests/
    tests.cmake
    test_something.cpp
  CMakeLists.txt
```

Upon configuring CMake:

- **Shared**, **static**, **header**, **executable** targets are generated automatically.
- **Test** executables are created and registered if `BUILD_TESTING` is ON.

---

## Usage

1. **Download** `bootstrap.cmake` from this repository (preferably a pinned version), or **copy** the `.cmake_utilities`
   folder locally.
2. In your top-level `CMakeLists.txt`, include both:
   ```cmake
   include("${CMAKE_BINARY_DIR}/bootstrap.cmake")
   include(".cmake_utilities/all.cmake")
   ```
3. Any directory that has `executable.cmake`, `header.cmake`, `shared.cmake`, `static.cmake`, or `tests.cmake` will be
   **automatically picked up** and turned into the relevant target.

For more detailed information, see the inline documentation within the scripts in this repository.
