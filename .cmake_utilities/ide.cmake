include_guard(GLOBAL)

# Suppress CMake warnings caused by IDEs
# automatically defining unused variables

if (DEFINED CMAKE_C_COMPILER)
    set(_IGNORE_UNUSED_CMAKE_C_COMPILER "${CMAKE_C_COMPILER}")
endif ()

if (DEFINED Python_EXECUTABLE)
    set(_IGNORE_UNUSED_Python_EXECUTABLE "${Python_EXECUTABLE}")
endif ()

if (DEFINED Python3_EXECUTABLE)
    set(_IGNORE_UNUSED_Python3_EXECUTABLE "${Python3_EXECUTABLE}")
endif ()

if (DEFINED BUILD_TESTING)
    set(_IGNORE_UNUSED_BUILD_TESTING "${BUILD_TESTING}")
endif ()
