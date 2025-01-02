CMake Utilities
===

This repository contains some utilities that I use with some of my projects.
The utilities are only tested on linux and windows.

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
