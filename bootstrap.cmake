cmake_minimum_required(VERSION 3.14)

set(CMAKE_UTILITIES_VERSION "main" CACHE STRING "The Version of CMakeUtilities to use")
if (CMAKE_UTILITIES_VERSION STREQUAL "main")
    set(CMAKE_UTILITIES_BASE_URL "https://raw.githubusercontent.com/rawbby/cmake_utilities/refs/heads/main")
else ()
    set(CMAKE_UTILITIES_BASE_URL "https://raw.githubusercontent.com/rawbby/cmake_utilities/refs/tags/${CMAKE_UTILITIES_VERSION}")
endif ()

set(LOCK_RESULT 1)
while (LOCK_RESULT)
    file(LOCK "${CMAKE_SOURCE_DIR}/.cmake_utilities/download.lock" GUARD FILE RESULT_VARIABLE LOCK_RESULT)
endwhile ()

if (NOT EXISTS "${CMAKE_SOURCE_DIR}/.cmake_utilities/.valid")

    set(FILENAMES
            "all.cmake"
            "export.h.in"
            "structured_directories.cmake")

    foreach (FILENAME ${FILENAMES})
        file(DOWNLOAD
                "${CMAKE_UTILITIES_BASE_URL}/.cmake_utilities/${FILENAME}"
                "${CMAKE_SOURCE_DIR}/.cmake_utilities/${FILENAME}"
                STATUS DOWNLOAD_STATUS)
        list(GET DOWNLOAD_STATUS 0 DOWNLOAD_CODE)
        list(GET DOWNLOAD_STATUS 1 DOWNLOAD_MESSAGE)
        if (NOT ${DOWNLOAD_CODE} EQUAL 0)
            message("${CMAKE_UTILITIES_BASE_URL}/.cmake_utilities/${FILENAME}")
            message(FATAL_ERROR "File download failed with error code: ${DOWNLOAD_CODE} ${DOWNLOAD_MESSAGE}")
        endif ()
    endforeach ()

    file(WRITE "${CMAKE_SOURCE_DIR}/.cmake_utilities/.valid" "")
endif ()
