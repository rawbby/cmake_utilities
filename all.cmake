include_guard(GLOBAL)

message("${PROJECT_NAME} - Added CMake Script         all.cmake")

if (PROJECT_NAME STREQUAL "CMakeUtilities")
    file(GLOB _INCLUDES "${CMAKE_SOURCE_DIR}/*.cmake")
else ()
    file(GLOB _INCLUDES "${CMAKE_SOURCE_DIR}/.cmake_utilities/*.cmake")
endif ()

foreach (_INCLUDE ${_INCLUDES})
    get_filename_component(_INCLUDE_NAME "${_INCLUDE}" NAME)
    if (NOT (_INCLUDE_NAME STREQUAL "all.cmake" OR _INCLUDE_NAME STREQUAL "bootstrap.cmake"))
        include(${_INCLUDE})
        message("${PROJECT_NAME} - Added CMake Script         ${_INCLUDE_NAME}")
    endif ()
endforeach ()

# TIDY UP
unset(_INCLUDE)
unset(_INCLUDES)
unset(_INCLUDE_NAME)
