include_guard(GLOBAL)

function(glob_sources OUT_VARIABLE CXX_SOURCE_DIRECTORY)
    foreach (CXX_SOURCE_FILE_EXTENSION ${CMAKE_CXX_SOURCE_FILE_EXTENSIONS})
        cmake_path(APPEND CXX_SOURCE_PATTERN "${CXX_SOURCE_DIRECTORY}" "*.${CXX_SOURCE_FILE_EXTENSION}")
        list(APPEND CXX_SOURCE_PATTERNS "${CXX_SOURCE_PATTERN}")
    endforeach ()
    file(GLOB_RECURSE ${OUT_VARIABLE} ${CXX_SOURCE_PATTERNS})
    set(${OUT_VARIABLE} ${${OUT_VARIABLE}} PARENT_SCOPE)
endfunction()

block()
    file(GLOB_RECURSE GLOB_PATHS "${CMAKE_SOURCE_DIR}/*.cmake")
    foreach (GLOB_PATH ${GLOB_PATHS})
        get_filename_component(ABS_GLOB_PATH "${GLOB_PATH}" ABSOLUTE)
        get_filename_component(ABS_GLOB_NAME "${ABS_GLOB_PATH}" NAME)
        get_filename_component(ABS_GLOB_DIR "${ABS_GLOB_PATH}" DIRECTORY)
        string(FIND "${ABS_GLOB_DIR}" "${CMAKE_SOURCE_DIR}/.cmake_utilities" POS)
        if (POS EQUAL 0)
            continue()
        endif ()

        if (ABS_GLOB_NAME STREQUAL "shared.cmake")
            list(APPEND SHARED_DIRS "${ABS_GLOB_DIR}")
        elseif (ABS_GLOB_NAME STREQUAL "static.cmake")
            list(APPEND STATIC_DIRS "${ABS_GLOB_DIR}")
        elseif (ABS_GLOB_NAME STREQUAL "header.cmake")
            list(APPEND HEADER_DIRS "${ABS_GLOB_DIR}")
        elseif (ABS_GLOB_NAME STREQUAL "executable.cmake")
            list(APPEND EXEC_DIRS "${ABS_GLOB_DIR}")
        elseif (BUILD_TESTING AND ABS_GLOB_NAME STREQUAL "tests.cmake")
            list(APPEND TEST_DIRS "${ABS_GLOB_DIR}")
        endif ()
    endforeach ()

    set(SHARED_DIRS ${SHARED_DIRS} PARENT_SCOPE)
    set(STATIC_DIRS ${STATIC_DIRS} PARENT_SCOPE)
    set(HEADER_DIRS ${HEADER_DIRS} PARENT_SCOPE)
    set(EXEC_DIRS ${EXEC_DIRS} PARENT_SCOPE)
    set(TEST_DIRS ${TEST_DIRS} PARENT_SCOPE)
endblock()
