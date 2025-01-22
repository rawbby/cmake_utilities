include_guard(GLOBAL)

include("${CMAKE_SOURCE_DIR}/.cmake_utilities/all.cmake")

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib" CACHE STRING "Unified Output Directory for Archives")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib" CACHE STRING "Unified Output Directory for Libraries")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin" CACHE STRING "Unified Output Directory for Executables")

set(CMAKE_ARCHIVE_INSTALL_DIRECTORY "${CMAKE_INSTALL_PREFIX}/lib" CACHE STRING "Unified Install Directory for Archives")
set(CMAKE_LIBRARY_INSTALL_DIRECTORY "${CMAKE_INSTALL_PREFIX}/lib" CACHE STRING "Unified Install Directory for Libraries")
set(CMAKE_RUNTIME_INSTALL_DIRECTORY "${CMAKE_INSTALL_PREFIX}/bin" CACHE STRING "Unified Install Directory for Executables")
set(CMAKE_INCLUDE_INSTALL_DIRECTORY "${CMAKE_INSTALL_PREFIX}/include" CACHE STRING "Unified Install Directory for Includes")

set(CMAKE_CXX_STANDARD 20 CACHE INTERNAL "The C++ Standard this Project relies on")
set(CMAKE_CXX_STANDARD_REQUIRED ON CACHE BOOL "Require a specific C++ Standard")
set(CMAKE_CXX_EXTENSIONS OFF CACHE BOOL "Allow Extensions that are not Part of the pure C++ Standard")

option(BUILD_TESTING "Build Tests" OFF)

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

function(file_glob_source OUT_VAR BASE_DIR)
    file(GLOB_RECURSE _TMP
            "${BASE_DIR}/*.c"
            "${BASE_DIR}/*.cc"
            "${BASE_DIR}/*.cp"
            "${BASE_DIR}/*.cpp"
            "${BASE_DIR}/*.cxx")
    list(APPEND ${OUT_VAR} ${_TMP})
    set(${OUT_VAR} "${${OUT_VAR}}" PARENT_SCOPE)
endfunction()

function(file_glob_header OUT_VAR BASE_DIR)
    file(GLOB_RECURSE _TMP
            "${BASE_DIR}/*.h"
            "${BASE_DIR}/*.hh"
            "${BASE_DIR}/*.hp"
            "${BASE_DIR}/*.hpp"
            "${BASE_DIR}/*.hxx")
    list(APPEND ${OUT_VAR} ${_TMP})
    set(${OUT_VAR} "${${OUT_VAR}}" PARENT_SCOPE)
endfunction()

function(upper_snake_case OUT_VAR IN_VAR)
    set(${OUT_VAR} "${IN_VAR}")
    string(REGEX MATCH "[a-z]" "${${OUT_VAR}}" CONTAINS_LOWER)
    if (CONTAINS_LOWER)
        string(REGEX REPLACE "([A-Z])" "_\\1" ${OUT_VAR} "${${OUT_VAR}}")
    endif ()
    string(REGEX REPLACE "[^A-Za-z0-9]+" "_" ${OUT_VAR} "${${OUT_VAR}}")
    string(REGEX REPLACE "_+" "_" ${OUT_VAR} "${${OUT_VAR}}")
    string(REGEX REPLACE "^_+" "" ${OUT_VAR} "${${OUT_VAR}}")
    string(TOUPPER "${${OUT_VAR}}" ${OUT_VAR})
    set(${OUT_VAR} "${${OUT_VAR}}" PARENT_SCOPE)
endfunction()

foreach (TARGET_DIR ${SHARED_DIRS})
    block()
        get_filename_component(TARGET_NAME "${TARGET_DIR}" NAME)
        upper_snake_case(TARGET_NAME_USC "${TARGET_NAME}")
        set(TARGET_EXPORT_FILE_NAME "${TARGET_NAME}_export.h")
        set(TARGET_SRC)
        set(TARGET_SOURCE)
        set(TARGET_INC)
        set(TARGET_INCLUDE)
        file_glob_source(TARGET_SRC "${TARGET_DIR}/src")
        file_glob_header(TARGET_SRC "${TARGET_DIR}/src")
        file_glob_source(TARGET_SOURCE "${TARGET_DIR}/source")
        file_glob_header(TARGET_SOURCE "${TARGET_DIR}/source")
        file_glob_header(TARGET_INC "${TARGET_DIR}/inc")
        file_glob_header(TARGET_INCLUDE "${TARGET_DIR}/include")
        set(TARGET_CXX_STANDARD "${CMAKE_CXX_STANDARD}")
        set(TARGET_CXX_STANDARD_REQUIRED "${CMAKE_CXX_STANDARD_REQUIRED}")
        set(TARGET_CXX_EXTENSIONS "${CMAKE_CXX_EXTENSIONS}")
        set(TARGET_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
        set(TARGET_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")
        set(TARGET_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}")
        set(TARGET_RUNTIME_INSTALL_DIRECTORY "${CMAKE_RUNTIME_INSTALL_DIRECTORY}")
        set(TARGET_LIBRARY_INSTALL_DIRECTORY "${CMAKE_LIBRARY_INSTALL_DIRECTORY}")
        set(TARGET_ARCHIVE_INSTALL_DIRECTORY "${CMAKE_ARCHIVE_INSTALL_DIRECTORY}")
        set(TARGET_INCLUDE_INSTALL_DIRECTORY "${CMAKE_INCLUDE_INSTALL_DIRECTORY}")

        add_library(${TARGET_NAME} SHARED)
        include("${TARGET_DIR}/shared.cmake")

        configure_file(
                "${CMAKE_SOURCE_DIR}/.cmake_utilities/export.h.in"
                "${CMAKE_CURRENT_BINARY_DIR}/${TARGET_NAME}/include/${TARGET_EXPORT_FILE_NAME}"
                @ONLY)
        target_include_directories(${TARGET_NAME}
                PUBLIC
                $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/${TARGET_NAME}/include/>
                $<INSTALL_INTERFACE:${TARGET_INCLUDE_INSTALL_DIRECTORY}>)
        set_target_properties(${TARGET_NAME} PROPERTIES
                LINKER_LANGUAGE CXX
                CXX_STANDARD ${TARGET_CXX_STANDARD}
                CXX_STANDARD_REQUIRED ${TARGET_CXX_STANDARD_REQUIRED}
                CXX_EXTENSIONS ${TARGET_CXX_EXTENSIONS}
                POSITION_INDEPENDENT_CODE ON
                RUNTIME_OUTPUT_DIRECTORY "${TARGET_RUNTIME_OUTPUT_DIRECTORY}"
                LIBRARY_OUTPUT_DIRECTORY "${TARGET_LIBRARY_OUTPUT_DIRECTORY}"
                ARCHIVE_OUTPUT_DIRECTORY "${TARGET_ARCHIVE_OUTPUT_DIRECTORY}")
        target_compile_definitions(${TARGET_NAME} PRIVATE
                "${TARGET_NAME_USC}_EXPORTS")
        target_sources(${TARGET_NAME} PRIVATE ${TARGET_SRC})
        target_sources(${TARGET_NAME} PRIVATE ${TARGET_SOURCE})
        target_sources(${TARGET_NAME} PRIVATE ${TARGET_INC})
        target_sources(${TARGET_NAME} PUBLIC ${TARGET_INCLUDE})
        install(TARGETS ${TARGET_NAME}
                EXPORT ${TARGET_NAME}Targets
                RUNTIME DESTINATION "${TARGET_RUNTIME_INSTALL_DIRECTORY}"
                LIBRARY DESTINATION "${TARGET_LIBRARY_INSTALL_DIRECTORY}"
                ARCHIVE DESTINATION "${TARGET_ARCHIVE_INSTALL_DIRECTORY}")
        install(DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/${TARGET_NAME}/include/" DESTINATION "${TARGET_INCLUDE_INSTALL_DIRECTORY}")
        if (TARGET_INC)
            target_include_directories(${TARGET_NAME} PRIVATE "${TARGET_DIR}/inc/")
        endif ()
        if (TARGET_INCLUDE)
            target_include_directories(${TARGET_NAME} PUBLIC "${TARGET_DIR}/include/")
            install(DIRECTORY "${TARGET_DIR}/include/" DESTINATION "${TARGET_INCLUDE_INSTALL_DIRECTORY}")
        endif ()
        message("${PROJECT_NAME} - Added Shared Library       ${TARGET_NAME}")
    endblock()
endforeach ()

foreach (TARGET_DIR ${STATIC_DIRS})
    block()
        get_filename_component(TARGET_NAME "${TARGET_DIR}" NAME)
        set(TARGET_SRC)
        set(TARGET_SOURCE)
        set(TARGET_INC)
        set(TARGET_INCLUDE)
        file_glob_source(TARGET_SRC "${TARGET_DIR}/src")
        file_glob_header(TARGET_SRC "${TARGET_DIR}/src")
        file_glob_source(TARGET_SOURCE "${TARGET_DIR}/source")
        file_glob_header(TARGET_SOURCE "${TARGET_DIR}/source")
        file_glob_header(TARGET_INC "${TARGET_DIR}/inc")
        file_glob_header(TARGET_INCLUDE "${TARGET_DIR}/include")
        set(TARGET_CXX_STANDARD "${CMAKE_CXX_STANDARD}")
        set(TARGET_CXX_STANDARD_REQUIRED "${CMAKE_CXX_STANDARD_REQUIRED}")
        set(TARGET_CXX_EXTENSIONS "${CMAKE_CXX_EXTENSIONS}")
        set(TARGET_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
        set(TARGET_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")
        set(TARGET_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}")
        set(TARGET_RUNTIME_INSTALL_DIRECTORY "${CMAKE_RUNTIME_INSTALL_DIRECTORY}")
        set(TARGET_LIBRARY_INSTALL_DIRECTORY "${CMAKE_LIBRARY_INSTALL_DIRECTORY}")
        set(TARGET_ARCHIVE_INSTALL_DIRECTORY "${CMAKE_ARCHIVE_INSTALL_DIRECTORY}")
        set(TARGET_INCLUDE_INSTALL_DIRECTORY "${CMAKE_INCLUDE_INSTALL_DIRECTORY}")

        add_library(${TARGET_NAME} STATIC)
        include("${TARGET_DIR}/static.cmake")

        set_target_properties(${TARGET_NAME} PROPERTIES
                LINKER_LANGUAGE CXX
                CXX_STANDARD ${TARGET_CXX_STANDARD}
                CXX_STANDARD_REQUIRED ${TARGET_CXX_STANDARD_REQUIRED}
                CXX_EXTENSIONS ${TARGET_CXX_EXTENSIONS}
                RUNTIME_OUTPUT_DIRECTORY "${TARGET_RUNTIME_OUTPUT_DIRECTORY}"
                LIBRARY_OUTPUT_DIRECTORY "${TARGET_LIBRARY_OUTPUT_DIRECTORY}"
                ARCHIVE_OUTPUT_DIRECTORY "${TARGET_ARCHIVE_OUTPUT_DIRECTORY}")
        target_sources(${TARGET_NAME} PRIVATE ${TARGET_SRC})
        target_sources(${TARGET_NAME} PRIVATE ${TARGET_SOURCE})
        target_sources(${TARGET_NAME} PRIVATE ${TARGET_INC})
        target_sources(${TARGET_NAME} PUBLIC ${TARGET_INCLUDE})
        install(TARGETS ${TARGET_NAME}
                EXPORT ${TARGET_NAME}Targets
                RUNTIME DESTINATION "${TARGET_RUNTIME_INSTALL_DIRECTORY}"
                LIBRARY DESTINATION "${TARGET_LIBRARY_INSTALL_DIRECTORY}"
                ARCHIVE DESTINATION "${TARGET_ARCHIVE_INSTALL_DIRECTORY}")
        if (TARGET_INC)
            target_include_directories(${TARGET_NAME} PRIVATE "${TARGET_DIR}/inc/")
        endif ()
        if (TARGET_INCLUDE)
            target_include_directories(${TARGET_NAME} PUBLIC "${TARGET_DIR}/include/")
            install(DIRECTORY "${TARGET_DIR}/include/" DESTINATION "${TARGET_INCLUDE_INSTALL_DIRECTORY}")
        endif ()
        message("${PROJECT_NAME} - Added Static Library       ${TARGET_NAME}")
    endblock()
endforeach ()

foreach (TARGET_DIR ${HEADER_DIRS})
    block()
        get_filename_component(TARGET_NAME "${TARGET_DIR}" NAME)
        set(TARGET_INCLUDE)
        file_glob_header(TARGET_INCLUDE "${TARGET_DIR}/include")
        set(TARGET_CXX_STANDARD "${CMAKE_CXX_STANDARD}")
        set(TARGET_CXX_STANDARD_REQUIRED "${CMAKE_CXX_STANDARD_REQUIRED}")
        set(TARGET_CXX_EXTENSIONS "${CMAKE_CXX_EXTENSIONS}")
        set(TARGET_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
        set(TARGET_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")
        set(TARGET_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}")
        set(TARGET_RUNTIME_INSTALL_DIRECTORY "${CMAKE_RUNTIME_INSTALL_DIRECTORY}")
        set(TARGET_LIBRARY_INSTALL_DIRECTORY "${CMAKE_LIBRARY_INSTALL_DIRECTORY}")
        set(TARGET_ARCHIVE_INSTALL_DIRECTORY "${CMAKE_ARCHIVE_INSTALL_DIRECTORY}")
        set(TARGET_INCLUDE_INSTALL_DIRECTORY "${CMAKE_INCLUDE_INSTALL_DIRECTORY}")

        add_library(${TARGET_NAME} INTERFACE)
        include("${TARGET_DIR}/header.cmake")

        set_target_properties(${TARGET_NAME} PROPERTIES
                LINKER_LANGUAGE CXX
                CXX_STANDARD ${TARGET_CXX_STANDARD}
                CXX_STANDARD_REQUIRED ${TARGET_CXX_STANDARD_REQUIRED}
                CXX_EXTENSIONS ${TARGET_CXX_EXTENSIONS}
                RUNTIME_OUTPUT_DIRECTORY "${TARGET_RUNTIME_OUTPUT_DIRECTORY}"
                LIBRARY_OUTPUT_DIRECTORY "${TARGET_LIBRARY_OUTPUT_DIRECTORY}"
                ARCHIVE_OUTPUT_DIRECTORY "${TARGET_ARCHIVE_OUTPUT_DIRECTORY}")
        target_sources(${TARGET_NAME} INTERFACE ${TARGET_INCLUDE})
        install(TARGETS ${TARGET_NAME}
                EXPORT ${TARGET_NAME}Targets
                RUNTIME DESTINATION "${TARGET_RUNTIME_INSTALL_DIRECTORY}"
                LIBRARY DESTINATION "${TARGET_LIBRARY_INSTALL_DIRECTORY}"
                ARCHIVE DESTINATION "${TARGET_ARCHIVE_INSTALL_DIRECTORY}")
        if (TARGET_INCLUDE)
            target_include_directories(${TARGET_NAME} INTERFACE "${TARGET_DIR}/include/")
            install(DIRECTORY "${TARGET_DIR}/include/" DESTINATION "${TARGET_INCLUDE_INSTALL_DIRECTORY}")
        endif ()
        message("${PROJECT_NAME} - Added Header Library       ${TARGET_NAME}")
    endblock()
endforeach ()

foreach (TARGET_DIR ${EXEC_DIRS})
    block()
        get_filename_component(TARGET_NAME "${TARGET_DIR}" NAME)
        set(TARGET_SRC)
        set(TARGET_SOURCE)
        set(TARGET_INC)
        file_glob_source(TARGET_SRC "${TARGET_DIR}/src")
        file_glob_header(TARGET_SRC "${TARGET_DIR}/src")
        file_glob_source(TARGET_SOURCE "${TARGET_DIR}/source")
        file_glob_header(TARGET_SOURCE "${TARGET_DIR}/source")
        file_glob_header(TARGET_INC "${TARGET_DIR}/inc")
        set(TARGET_CXX_STANDARD "${CMAKE_CXX_STANDARD}")
        set(TARGET_CXX_STANDARD_REQUIRED "${CMAKE_CXX_STANDARD_REQUIRED}")
        set(TARGET_CXX_EXTENSIONS "${CMAKE_CXX_EXTENSIONS}")
        set(TARGET_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
        set(TARGET_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")
        set(TARGET_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}")
        set(TARGET_RUNTIME_INSTALL_DIRECTORY "${CMAKE_RUNTIME_INSTALL_DIRECTORY}")
        set(TARGET_LIBRARY_INSTALL_DIRECTORY "${CMAKE_LIBRARY_INSTALL_DIRECTORY}")
        set(TARGET_ARCHIVE_INSTALL_DIRECTORY "${CMAKE_ARCHIVE_INSTALL_DIRECTORY}")

        add_executable(${TARGET_NAME})
        include("${TARGET_DIR}/executable.cmake")

        set_target_properties(${TARGET_NAME} PROPERTIES
                LINKER_LANGUAGE CXX
                CXX_STANDARD ${TARGET_CXX_STANDARD}
                CXX_STANDARD_REQUIRED ${TARGET_CXX_STANDARD_REQUIRED}
                CXX_EXTENSIONS ${TARGET_CXX_EXTENSIONS}
                RUNTIME_OUTPUT_DIRECTORY "${TARGET_RUNTIME_OUTPUT_DIRECTORY}"
                LIBRARY_OUTPUT_DIRECTORY "${TARGET_LIBRARY_OUTPUT_DIRECTORY}"
                ARCHIVE_OUTPUT_DIRECTORY "${TARGET_ARCHIVE_OUTPUT_DIRECTORY}")
        target_sources(${TARGET_NAME} PRIVATE ${TARGET_SRC})
        target_sources(${TARGET_NAME} PRIVATE ${TARGET_SOURCE})
        target_sources(${TARGET_NAME} PRIVATE ${TARGET_INC})
        install(TARGETS ${TARGET_NAME}
                EXPORT ${TARGET_NAME}Targets
                RUNTIME DESTINATION "${TARGET_RUNTIME_INSTALL_DIRECTORY}"
                LIBRARY DESTINATION "${TARGET_LIBRARY_INSTALL_DIRECTORY}"
                ARCHIVE DESTINATION "${TARGET_ARCHIVE_INSTALL_DIRECTORY}")
        if (TARGET_INC)
            target_include_directories(${TARGET_NAME} PRIVATE "${TARGET_DIR}/inc/")
        endif ()
        message("${PROJECT_NAME} - Added Executable           ${TARGET_NAME}")
    endblock()
endforeach ()

if (BUILD_TESTING)
    enable_testing()
    foreach (TEST_DIR ${TEST_DIRS})
        set(TEST_FILES)
        file_glob_source(TEST_FILES "${TEST_DIR}")
        foreach (TARGET_SRC ${TEST_FILES})
            block()
                get_filename_component(TARGET_NAME "${TARGET_SRC}" NAME_WE)
                set(TARGET_CXX_STANDARD "${CMAKE_CXX_STANDARD}")
                set(TARGET_CXX_STANDARD_REQUIRED "${CMAKE_CXX_STANDARD_REQUIRED}")
                set(TARGET_CXX_EXTENSIONS "${CMAKE_CXX_EXTENSIONS}")
                set(TARGET_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
                set(TARGET_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")
                set(TARGET_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}")
                set(TARGET_RUNTIME_INSTALL_DIRECTORY "${CMAKE_RUNTIME_INSTALL_DIRECTORY}")
                set(TARGET_LIBRARY_INSTALL_DIRECTORY "${CMAKE_LIBRARY_INSTALL_DIRECTORY}")
                set(TARGET_ARCHIVE_INSTALL_DIRECTORY "${CMAKE_ARCHIVE_INSTALL_DIRECTORY}")

                add_executable(${TARGET_NAME})
                include("${TEST_DIR}/tests.cmake")

                set_target_properties(${TARGET_NAME} PROPERTIES
                        LINKER_LANGUAGE CXX
                        CXX_STANDARD ${TARGET_CXX_STANDARD}
                        CXX_STANDARD_REQUIRED ${TARGET_CXX_STANDARD_REQUIRED}
                        CXX_EXTENSIONS ${TARGET_CXX_EXTENSIONS}
                        RUNTIME_OUTPUT_DIRECTORY "${TARGET_RUNTIME_OUTPUT_DIRECTORY}"
                        LIBRARY_OUTPUT_DIRECTORY "${TARGET_LIBRARY_OUTPUT_DIRECTORY}"
                        ARCHIVE_OUTPUT_DIRECTORY "${TARGET_ARCHIVE_OUTPUT_DIRECTORY}")
                target_sources(${TARGET_NAME} PRIVATE ${TARGET_SRC})
                install(TARGETS ${TARGET_NAME}
                        EXPORT ${TARGET_NAME}Targets
                        RUNTIME DESTINATION "${TARGET_RUNTIME_INSTALL_DIRECTORY}"
                        LIBRARY DESTINATION "${TARGET_LIBRARY_INSTALL_DIRECTORY}"
                        ARCHIVE DESTINATION "${TARGET_ARCHIVE_INSTALL_DIRECTORY}")
                add_test(NAME "${TARGET_NAME}" COMMAND $<TARGET_FILE:${TARGET_NAME}>)
                message("${PROJECT_NAME} - Added Test                 ${TARGET_NAME}")
            endblock()
        endforeach ()
    endforeach ()
endif ()
