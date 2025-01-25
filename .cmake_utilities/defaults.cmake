include_guard(GLOBAL)

# Standard CMake output directory variables
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib" CACHE STRING "")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib" CACHE STRING "")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin" CACHE STRING "")

# Custom install directory variables (not in the CMake standard)
set(CMAKE_ARCHIVE_INSTALL_DIRECTORY "${CMAKE_INSTALL_PREFIX}/lib" CACHE STRING "Install destination for static libraries")
set(CMAKE_LIBRARY_INSTALL_DIRECTORY "${CMAKE_INSTALL_PREFIX}/lib" CACHE STRING "Install destination for shared libraries")
set(CMAKE_RUNTIME_INSTALL_DIRECTORY "${CMAKE_INSTALL_PREFIX}/bin" CACHE STRING "Install destination for executables")
set(CMAKE_INCLUDE_INSTALL_DIRECTORY "${CMAKE_INSTALL_PREFIX}/include" CACHE STRING "Install destination for headers")

# Specify the C++ standard and required settings
set(CMAKE_CXX_STANDARD 20 CACHE INTERNAL "")
set(CMAKE_CXX_STANDARD_REQUIRED ON CACHE BOOL "")
set(CMAKE_CXX_EXTENSIONS OFF CACHE BOOL "")

# Enable or disable building of test targets
option(BUILD_TESTING "Build Tests" OFF)
