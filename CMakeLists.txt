cmake_minimum_required(VERSION 3.14)

project(CMakeUtilities LANGUAGES CXX)

option(CMAKE_UTILITIES_TEST "Run Tests on the CMakeUtilities Project" OFF)
if (CMAKE_UTILITIES_TEST)

    include(test/test.cmake)

endif ()
