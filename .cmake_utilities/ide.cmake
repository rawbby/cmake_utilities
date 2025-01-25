include_guard(GLOBAL)

# Suppress CMake warnings caused by IDEs
# automatically defining unused variables
set(_IGNORE_UNUSED_CMAKE_C_COMPILER "${CMAKE_C_COMPILER}")
set(_IGNORE_UNUSED_Python_EXECUTABLE "${Python_EXECUTABLE}")
set(_IGNORE_UNUSED_Python3_EXECUTABLE "${Python3_EXECUTABLE}")
