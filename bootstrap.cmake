cmake_minimum_required(VERSION 3.14)

set(CMAKE_UTILITIES_VERSION "v2.1.4" CACHE STRING "The Version of CMakeUtilities to use")

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
                "all.cmake"
                "bootstrap.py"
                "bootstrap_python.cmake"
                "defaults.cmake"
                "export.h.in"
                "glob.cmake"
                "ide.cmake"
                "string.cmake"
                "structured_directories.cmake"
                "target_utilities.cmake")

        foreach (FILENAME ${FILENAMES})
            file(DOWNLOAD
                    "${BASE_URL}/.cmake_utilities/${FILENAME}"
                    "${CMAKE_SOURCE_DIR}/.cmake_utilities/${FILENAME}"
                    STATUS DOWNLOAD_STATUS)
            list(GET DOWNLOAD_STATUS 0 DOWNLOAD_CODE)
            if (NOT ${DOWNLOAD_CODE} EQUAL 0)
                list(GET DOWNLOAD_STATUS 1 DOWNLOAD_MESSAGE)
                message(FATAL_ERROR "File Download failed with Error Code: ${DOWNLOAD_CODE} ${DOWNLOAD_MESSAGE}")
            endif ()
        endforeach ()

        file(WRITE "${CMAKE_SOURCE_DIR}/.cmake_utilities/.valid" "")
    endif ()

endblock()
