cmake_minimum_required(VERSION 3.14)

file(LOCK "${CMAKE_CURRENT_SOURCE_DIR}/.cmake_utilities/.download_lock" DIRECTORY GUARD FILE WAIT)

if (NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/.cmake_utilities/.valid")

    set(FILENAMES
            "add_executable_directory.cmake"
            "add_executables_directory.cmake"
            "add_libraries_directory.cmake"
            "add_library_directory.cmake"
            "all.cmake"
            "cxx20.cmake"
            "LICENSE"
            "normalise_output_directories.cmake"
            "README.md"
            "util.cmake")

    foreach (FILENAME ${FILENAMES})
        file(DOWNLOAD
                "https://raw.githubusercontent.com/rawbby/cmake_utilities/v1.2.0/${FILENAME}"
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

file(UNLOCK "${CMAKE_CURRENT_SOURCE_DIR}/.cmake_utilities/.download_lock" DIRECTORY GUARD FILE)
