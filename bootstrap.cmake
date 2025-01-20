cmake_minimum_required(VERSION 3.14)

set(CMAKE_UTILITIES_VERSION "main" CACHE STRING "")

file(LOCK "${CMAKE_CURRENT_SOURCE_DIR}/.cmake_utilities/download.lock" GUARD FILE RESULT_VARIABLE LOCK_RESULT)
if (LOCK_RESULT)
    message(FATAL_ERROR "failed to acquire download.lock")
endif ()

if (NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/.cmake_utilities/.valid")

    if (CMAKE_UTILITIES_VERSION STREQUAL "main")
        set(CMAKE_UTILITIES_BASE_URL "https://raw.githubusercontent.com/rawbby/cmake_utilities/refs/heads/main")
    else ()
        set(CMAKE_UTILITIES_BASE_URL "https://raw.githubusercontent.com/rawbby/cmake_utilities/refs/tags/${CMAKE_UTILITIES_VERSION}")
    endif ()

    set(FILENAMES
            "add_executable_directory.cmake"
            "add_executables_directory.cmake"
            "add_libraries_directory.cmake"
            "add_library_directory.cmake"
            "add_tests_directory.cmake"
            "all.cmake"
            "cxx20.cmake"
            "LICENSE"
            "normalise_output_directories.cmake"
            "README.md"
            "util.cmake")

    foreach (FILENAME ${FILENAMES})
        file(DOWNLOAD
                "${CMAKE_UTILITIES_BASE_URL}/${FILENAME}"
                "${CMAKE_CURRENT_SOURCE_DIR}/.cmake_utilities/${FILENAME}"
                STATUS DOWNLOAD_STATUS)
        list(GET DOWNLOAD_STATUS 0 DOWNLOAD_CODE)
        if (NOT ${DOWNLOAD_CODE} EQUAL 0)
            file(UNLOCK "${CMAKE_CURRENT_SOURCE_DIR}/.cmake_utilities/.download_lock" DIRECTORY GUARD FILE)
            message(FATAL_ERROR "File download failed with error code: ${DOWNLOAD_CODE}")
        endif ()
    endforeach ()

    file(WRITE "${CMAKE_CURRENT_SOURCE_DIR}/.cmake_utilities/.valid" "")
endif ()

file(UNLOCK "${CMAKE_CURRENT_SOURCE_DIR}/.cmake_utilities/download.lock" DIRECTORY GUARD FILE)
