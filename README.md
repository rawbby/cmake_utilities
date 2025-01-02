CMake Utilities
===

This repository contains some utilities that I use with some of my projects.
The utilities are only tested on linux and windows.

Sample usage
---

```cmake
cmake_minimum_required(VERSION 3.24)

project(sample)

function(download_extract_tar_gz)
    cmake_parse_arguments(PARSE_ARGV 0 ARG "" "URL;EXTRACT_DIR;STRIP" "")

    file(DOWNLOAD "${ARG_URL}" "${CMAKE_BINARY_DIR}/temp.tar.gz" STATUS DOWNLOAD_STATUS)

    list(GET DOWNLOAD_STATUS 0 DOWNLOAD_STATUS)
    if (NOT ${DOWNLOAD_STATUS} EQUAL 0)
        message(FATAL_ERROR "File download failed with error code: ${DOWNLOAD_STATUS}")
    endif ()

    file(MAKE_DIRECTORY "${ARG_EXTRACT_DIR}")

    if (ARG_STRIP)
        file(MAKE_DIRECTORY "${CMAKE_BINARY_DIR}/temp")
        file(ARCHIVE_EXTRACT INPUT "${CMAKE_BINARY_DIR}/temp.tar.gz" DESTINATION "${CMAKE_BINARY_DIR}/temp")
        file(GLOB EXTRACTED_CONTENT "${CMAKE_BINARY_DIR}/temp/*")
        foreach (ITEM ${EXTRACTED_CONTENT})
            if (IS_DIRECTORY ${ITEM})
                file(GLOB SUB_ITEMS "${ITEM}/*")
                foreach (SUB_ITEM ${SUB_ITEMS})
                    file(COPY ${SUB_ITEM} DESTINATION ${ARG_EXTRACT_DIR})
                endforeach ()
            else ()
                file(COPY ${ITEM} DESTINATION ${ARG_EXTRACT_DIR})
            endif ()
        endforeach ()
        file(REMOVE_RECURSE "${CMAKE_BINARY_DIR}/temp")
    else ()
        file(ARCHIVE_EXTRACT INPUT "${CMAKE_BINARY_DIR}/temp.tar.gz" DESTINATION "${ARG_EXTRACT_DIR}")
    endif ()

endfunction()

if (NOT EXISTS "${PROJECT_SOURCE_DIR}/cmake")
    message("test")
    download_extract_tar_gz(
            URL "https://codeload.github.com/rawbby/cmake_utilities/tar.gz/refs/tags/v1.0.0"
            EXTRACT_DIR "${PROJECT_SOURCE_DIR}/cmake"
            STRIP ON)
endif ()

include(cmake/all.cmake)
```
