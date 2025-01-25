cmake_minimum_required(VERSION 3.14)

project(CMakeUtilities LANGUAGES CXX)

include(.cmake_utilities/all.cmake)

bootstrap_python()
use_structured_directories()

execute_python("${CMAKE_SOURCE_DIR}/test/test.py")
