include_guard(GLOBAL)

if (PROJECT_NAME STREQUAL "CMakeUtilities")
    set(CMAKE_UTILITIES_BASE_DIR "${CMAKE_SOURCE_DIR}")
else ()
    set(CMAKE_UTILITIES_BASE_DIR "${CMAKE_SOURCE_DIR}/.cmake_utilities")
endif ()

include("${CMAKE_UTILITIES_BASE_DIR}/add_executable_directory.cmake")
include("${CMAKE_UTILITIES_BASE_DIR}/util.cmake")

function(add_executables_directory TARGETS_BASE_DIR)

    if (EXISTS "${CMAKE_SOURCE_DIR}/${TARGETS_BASE_DIR}")
        set(TARGETS_BASE_DIR "${CMAKE_SOURCE_DIR}/${TARGETS_BASE_DIR}")
    endif ()

    get_filename_component(TARGETS_ABS_DIR "${TARGETS_BASE_DIR}" ABSOLUTE)
    abs_dirs_from_glob(TARGET_ABS_DIRS "${TARGETS_ABS_DIR}/**/target.cmake")

    foreach (TARGET_ABS_DIR ${TARGET_ABS_DIRS})
        file(RELATIVE_PATH TARGET_REL_DIR "${TARGETS_ABS_DIR}" "${TARGET_ABS_DIR}")
        add_executable_directory("${TARGETS_ABS_DIR}" "${TARGET_REL_DIR}")
    endforeach ()

endfunction()
