file(DOWNLOAD
        "https://codeload.github.com/rawbby/cmake_utilities/tar.gz/refs/tags/v1.0.0"
        "${CMAKE_BINARY_DIR}/temp.tar.gz"
        STATUS DOWNLOAD_STATUS)

list(GET DOWNLOAD_STATUS 0 DOWNLOAD_STATUS)
if (NOT ${DOWNLOAD_STATUS} EQUAL 0)
    message(FATAL_ERROR "File download failed with error code: ${DOWNLOAD_STATUS}")
endif ()

file(MAKE_DIRECTORY "${PROJECT_SOURCE_DIR}/cmake")
file(MAKE_DIRECTORY "${CMAKE_BINARY_DIR}/temp")
file(ARCHIVE_EXTRACT INPUT "${CMAKE_BINARY_DIR}/temp.tar.gz" DESTINATION "${CMAKE_BINARY_DIR}/temp")
file(GLOB EXTRACTED_CONTENT "${CMAKE_BINARY_DIR}/temp/*")
foreach (ITEM ${EXTRACTED_CONTENT})
    if (IS_DIRECTORY ${ITEM})
        file(GLOB SUB_ITEMS "${ITEM}/*")
        foreach (SUB_ITEM ${SUB_ITEMS})
            file(COPY ${SUB_ITEM} DESTINATION "${PROJECT_SOURCE_DIR}/cmake")
        endforeach ()
    else ()
        file(COPY ${ITEM} DESTINATION "${PROJECT_SOURCE_DIR}/cmake")
    endif ()
endforeach ()
file(REMOVE_RECURSE "${CMAKE_BINARY_DIR}/temp")
