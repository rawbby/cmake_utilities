cmake_minimum_required(VERSION 3.14)

set(CMAKE_UTILITIES_VERSION "v2.3.4" CACHE STRING "The Version of CMakeUtilities to use")

block()

    if (CMAKE_UTILITIES_VERSION STREQUAL "main")
        set(BASE_URL "https://raw.githubusercontent.com/rawbby/cmake_utilities/refs/heads/main")
    else ()
        set(BASE_URL "https://raw.githubusercontent.com/rawbby/cmake_utilities/refs/tags/${CMAKE_UTILITIES_VERSION}")
    endif ()

    set(LOCK_RESULT 1)
    while (LOCK_RESULT)
        file(LOCK "${CMAKE_SOURCE_DIR}/.cmake_utilities/.lock" GUARD FILE RESULT_VARIABLE LOCK_RESULT)
    endwhile ()

    if (NOT EXISTS "${CMAKE_SOURCE_DIR}/.cmake_utilities/.valid")
        set(FILENAMES
                "modules/structured_directories/common.cmake"
                "modules/structured_directories/executable.cmake"
                "modules/structured_directories/export.h.in"
                "modules/structured_directories/header.cmake"
                "modules/structured_directories/shared.cmake"
                "modules/structured_directories/static.cmake"
                "modules/structured_directories/test.cmake"
                "scripts/run_clang_tidy.cmake"
                "scripts/run_clang_format.cmake"
                "scripts/bootstrap.py"
                "modules/structured_directories.cmake"
                "modules/python_venv.cmake"
                "modules/default.cmake"
                "modules/clang_tidy.cmake"
                "modules/clang_format.cmake"
                "modules/all.cmake")

        foreach (FILENAME ${FILENAMES})
            file(DOWNLOAD "${BASE_URL}/.cmake_utilities/${FILENAME}" "${CMAKE_SOURCE_DIR}/.cmake_utilities/${FILENAME}" STATUS DOWNLOAD_STATUS)
            list(GET DOWNLOAD_STATUS 0 DOWNLOAD_CODE)
            if (NOT ${DOWNLOAD_CODE} EQUAL 0)
                list(GET DOWNLOAD_STATUS 1 DOWNLOAD_MESSAGE)
                message(FATAL_ERROR "File Download failed with Error Code: ${DOWNLOAD_CODE} ${DOWNLOAD_MESSAGE}")
            endif ()
        endforeach ()

        file(TOUCH "${CMAKE_SOURCE_DIR}/.cmake_utilities/.valid")
    endif ()

endblock()
