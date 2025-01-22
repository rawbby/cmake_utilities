CMake Utilities
===

This repository contains some utilities that I use with some of my projects.
The utilities are only tested on linux and windows.

Instead of declaring each target explicitly cmake_utilities allows the project to automatically detect and configure
targets. How is a target detected?
- executable directories contain a file executable.cmake
- shared library directories contain a file shared_library.cmake
- static library directories contain a file static_library.cmake
- header only library directories contain a file header_library.cmake

Sample usage
---

```cmake
cmake_minimum_required(VERSION 3.10)

project(sample)

file(DOWNLOAD "https://raw.githubusercontent.com/rawbby/cmake_utilities/refs/heads/main/bootstrap.cmake"
        "${PROJECT_SOURCE_DIR}/cmake/bootstrap.cmake")

include(cmake/bootstrap.cmake)
include(cmake/all.cmake)
```
