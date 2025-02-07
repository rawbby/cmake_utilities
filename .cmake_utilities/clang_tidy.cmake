include_guard(GLOBAL)

option(CLANG_TIDY_TARGET "Create a target for clang-tidy" OFF)

if (CMAKE_GENERATOR MATCHES "Visual Studio")
    message(WARNING "Visual Studio generator detected; disabling requested clang-tidy target!")
    set(CLANG_TIDY_TARGET OFF CACHE BOOL "Disable clang-tidy target for Visual Studio generator" FORCE)
endif ()

if (CLANG_TIDY_TARGET)
    find_program(CLANG_TIDY_EXECUTABLE NAMES clang-tidy)
    if (NOT CLANG_TIDY_EXECUTABLE)
        message(FATAL_ERROR "clang-tidy not found!")
    endif ()
    set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
    add_custom_target(clang_tidy)
    if (EXISTS "${CMAKE_SOURCE_DIR}/.clang-tidy")
        set(CLANG_TIDY_CONFIG_FILE_OPTION "--config-file=${CMAKE_SOURCE_DIR}/.clang-tidy")
    endif ()
endif ()

function(clang_tidy_sources)
    if (CLANG_TIDY_TARGET)
        add_custom_command(
                TARGET clang_tidy
                PRE_BUILD
                WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
                COMMAND "${CLANG_TIDY_EXECUTABLE}"
                "${CLANG_TIDY_CONFIG_FILE_OPTION}"
                -p="${CMAKE_BINARY_DIR}"
                -fix
                -fix-errors
                ${ARGN})
    endif ()
endfunction()
