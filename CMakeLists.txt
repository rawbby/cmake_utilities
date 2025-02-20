cmake_minimum_required(VERSION 3.14)

project(CMakeUtilities LANGUAGES CXX)

include(.cmake_utilities/modules/all.cmake)

python("${CMAKE_SOURCE_DIR}/test/test.py")
