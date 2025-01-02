CMake Utilities
===

This repository contains some utilities that I use with some of my projects.
The utilities are only tested on linux and windows.

Sample usage
---

```cmake
cmake_minimum_required(VERSION 3.24)

project(sample)

file(DOWNLOAD "https://github.com/rawbby/cmake_utilities/blob/v1.0.0/bootstrap.cmake"
        "${PROJECT_SOURCE_DIR}/cmake/bootstrap.cmake")
include(cmake/bootstrap.cmake)
```
