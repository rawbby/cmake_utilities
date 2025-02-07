include_guard(GLOBAL)

option(CLANG_FORMAT_TARGET "Create a target for clang-format" OFF)

if (CLANG_FORMAT_TARGET)
    find_program(CLANG_FORMAT_EXECUTABLE NAMES clang-format)
    if (NOT CLANG_FORMAT_EXECUTABLE)
        message(FATAL_ERROR "clang-format not found!")
    endif ()
    add_custom_target(clang_format)
    if (EXISTS "${CMAKE_SOURCE_DIR}/.clang-format")
        set(CLANG_FORMAT_CONFIG_FILE_OPTION "--style=file:${CMAKE_SOURCE_DIR}/.clang-format")
    endif ()
endif ()

function(clang_format_sources)
    if (CLANG_FORMAT_TARGET)
        add_custom_command(
                TARGET clang_format
                PRE_BUILD
                WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
                COMMAND "${CLANG_FORMAT_EXECUTABLE}"
                "${CLANG_FORMAT_CONFIG_FILE_OPTION}"
                --Werror
                -i
                ${ARGN})
    endif ()
endfunction()
