cmake_minimum_required(VERSION 3.14)

set(CMAKE_UTILITIES_VERSION "v2.3.14" CACHE STRING "The Version of CMakeUtilities to use")

function(cmake_utilities_bootstrap)
    set(BASE_URL "https://raw.githubusercontent.com/rawbby/cmake_utilities/refs/tags/${CMAKE_UTILITIES_VERSION}")

    set(LOCK_RESULT 1)
    while (LOCK_RESULT)
        file(LOCK "${CMAKE_SOURCE_DIR}/.cmake_utilities/.lock" GUARD FUNCTION RESULT_VARIABLE LOCK_RESULT)
    endwhile ()

    if (NOT EXISTS "${CMAKE_SOURCE_DIR}/.cmake_utilities/.valid")
        set(FILENAMES
                "modules/structured_directories/common.cmake"
                "modules/structured_directories/executable.cmake"
                "modules/structured_directories/export.h.in"
                "modules/structured_directories/extern.cmake"
                "modules/structured_directories/header.cmake"
                "modules/structured_directories/shared.cmake"
                "modules/structured_directories/static.cmake"
                "modules/structured_directories/test.cmake"
                "modules/all.cmake"
                "modules/clang_format.cmake"
                "modules/clang_tidy.cmake"
                "modules/default.cmake"
                "modules/python_venv.cmake"
                "modules/structured_directories.cmake"
                "scripts/bootstrap.py"
                "scripts/file_lock.py"
                "scripts/run.py"
                "scripts/run_clang_format.cmake"
                "scripts/run_clang_tidy.cmake")

        foreach (FILENAME ${FILENAMES})
            file(DOWNLOAD "${BASE_URL}/.cmake_utilities/${FILENAME}" "${CMAKE_SOURCE_DIR}/.cmake_utilities/${FILENAME}" STATUS DOWNLOAD_STATUS)
            list(GET DOWNLOAD_STATUS 0 DOWNLOAD_CODE)
            if (NOT ${DOWNLOAD_CODE} EQUAL 0)
                list(GET DOWNLOAD_STATUS 1 DOWNLOAD_MESSAGE)
                message(FATAL_ERROR "File Download failed with Error Code: ${DOWNLOAD_CODE} ${DOWNLOAD_MESSAGE} (${BASE_URL}/.cmake_utilities/${FILENAME})")
            endif ()
        endforeach ()

        file(TOUCH "${CMAKE_SOURCE_DIR}/.cmake_utilities/.valid")
    endif ()
endfunction()
cmake_utilities_bootstrap()
