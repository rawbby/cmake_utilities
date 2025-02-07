include_guard(GLOBAL)

include("${CMAKE_SOURCE_DIR}/.cmake_utilities/defaults.cmake")
include("${CMAKE_SOURCE_DIR}/.cmake_utilities/target_utilities.cmake")
include("${CMAKE_SOURCE_DIR}/.cmake_utilities/glob.cmake")
include("${CMAKE_SOURCE_DIR}/.cmake_utilities/string.cmake")

include(CTest)

function(use_structured_directories)

    # ======================================= #
    # Step 1: Find all structured Directories #
    # ======================================= #

    set(SHARED_DIRS)
    set(STATIC_DIRS)
    set(HEADER_DIRS)
    set(EXEC_DIRS)
    set(TEST_DIRS)

    file(GLOB_RECURSE GLOB_PATHS "${CMAKE_SOURCE_DIR}/*.cmake")
    foreach (GLOB_PATH ${GLOB_PATHS})

        get_filename_component(ABS_GLOB_PATH "${GLOB_PATH}" ABSOLUTE)
        get_filename_component(ABS_GLOB_NAME "${ABS_GLOB_PATH}" NAME)
        get_filename_component(ABS_GLOB_DIR "${ABS_GLOB_PATH}" DIRECTORY)

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

    # ================================================== #
    # Step 2: Create Targets from structured Directories #
    # ================================================== #

    foreach (TARGET_DIR ${SHARED_DIRS})
        block()
            get_filename_component(TARGET_NAME "${TARGET_DIR}" NAME)
            default_glob_sources()

            add_library(${TARGET_NAME} SHARED)
            include("${TARGET_DIR}/shared.cmake")

            default_target_properties()
            default_target_sources()
            default_target_install()

            default_shared_configuration()

            clang_tidy_sources(${TARGET_SRC} ${TARGET_SOURCE} ${TARGET_INC} ${TARGET_INCLUDE})
            clang_format_sources(${TARGET_SRC} ${TARGET_SOURCE} ${TARGET_INC} ${TARGET_INCLUDE})

            message("${PROJECT_NAME} - Added Shared Library       ${TARGET_NAME}")
        endblock()
    endforeach ()

    foreach (TARGET_DIR ${STATIC_DIRS})
        block()
            get_filename_component(TARGET_NAME "${TARGET_DIR}" NAME)
            default_glob_sources()

            add_library(${TARGET_NAME} STATIC)
            include("${TARGET_DIR}/static.cmake")

            default_target_properties()
            default_target_sources()
            default_target_install()

            clang_tidy_sources(${TARGET_SRC} ${TARGET_SOURCE} ${TARGET_INC} ${TARGET_INCLUDE})
            clang_format_sources(${TARGET_SRC} ${TARGET_SOURCE} ${TARGET_INC} ${TARGET_INCLUDE})

            message("${PROJECT_NAME} - Added Static Library       ${TARGET_NAME}")
        endblock()
    endforeach ()

    foreach (TARGET_DIR ${HEADER_DIRS})
        block()
            get_filename_component(TARGET_NAME "${TARGET_DIR}" NAME)
            default_glob_sources()

            add_library(${TARGET_NAME} INTERFACE)
            include("${TARGET_DIR}/header.cmake")

            default_target_properties()
            default_target_sources()
            default_target_install()

            clang_tidy_sources(${TARGET_SRC} ${TARGET_SOURCE} ${TARGET_INC} ${TARGET_INCLUDE})
            clang_format_sources(${TARGET_SRC} ${TARGET_SOURCE} ${TARGET_INC} ${TARGET_INCLUDE})

            message("${PROJECT_NAME} - Added Header Library       ${TARGET_NAME}")
        endblock()
    endforeach ()

    foreach (TARGET_DIR ${EXEC_DIRS})
        block()
            get_filename_component(TARGET_NAME "${TARGET_DIR}" NAME)
            default_glob_sources()

            add_executable(${TARGET_NAME})
            include("${TARGET_DIR}/executable.cmake")

            default_target_properties()
            default_target_sources()
            default_target_install()

            clang_tidy_sources(${TARGET_SRC} ${TARGET_SOURCE} ${TARGET_INC} ${TARGET_INCLUDE})
            clang_format_sources(${TARGET_SRC} ${TARGET_SOURCE} ${TARGET_INC} ${TARGET_INCLUDE})

            message("${PROJECT_NAME} - Added Executable           ${TARGET_NAME}")
        endblock()
    endforeach ()

    if (BUILD_TESTING)
        enable_testing()
        foreach (TEST_DIR ${TEST_DIRS})
            file_glob_source(TEST_FILES "${TEST_DIR}")
            foreach (TARGET_SRC ${TEST_FILES})
                block()
                    get_filename_component(TARGET_NAME "${TARGET_SRC}" NAME_WE)

                    add_executable(${TARGET_NAME})
                    include("${TEST_DIR}/tests.cmake")

                    default_target_properties()
                    target_sources(${TARGET_NAME} PRIVATE "${TARGET_SRC}")
                    default_target_install()

                    clang_tidy_sources(${TARGET_SRC})
                    clang_format_sources(${TARGET_SRC})

                    add_test(NAME "${TARGET_NAME}" COMMAND $<TARGET_FILE:${TARGET_NAME}>)
                    message("${PROJECT_NAME} - Added Test                 ${TARGET_NAME}")
                endblock()
            endforeach ()
        endforeach ()
    endif ()

endfunction()
