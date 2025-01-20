set(CMAKE_UTILITIES_VERSION "main" CACHE STRING "")
if (CMAKE_UTILITIES_VERSION STREQUAL "main")
    set(CMAKE_UTILITIES_BASE_URL "https://raw.githubusercontent.com/rawbby/cmake_utilities/refs/heads/main")
else ()
    set(CMAKE_UTILITIES_BASE_URL "https://raw.githubusercontent.com/rawbby/cmake_utilities/refs/tags/${CMAKE_UTILITIES_VERSION}")
endif ()

if (NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/.cmake_utilities/.valid")
    file(DOWNLOAD "${CMAKE_UTILITIES_BASE_URL}/bootstrap.cmake"
            "${CMAKE_CURRENT_SOURCE_DIR}/.cmake_utilities/bootstrap.cmake"
            STATUS DOWNLOAD_STATUS)
    list(GET DOWNLOAD_STATUS 0 DOWNLOAD_CODE)
    if (NOT ${DOWNLOAD_CODE} EQUAL 0)
        message(FATAL_ERROR "File download failed with error code: ${DOWNLOAD_CODE}")
    endif ()
    include("${CMAKE_CURRENT_SOURCE_DIR}/.cmake_utilities/bootstrap.cmake")
endif ()

include("${CMAKE_SOURCE_DIR}/.cmake_utilities/all.cmake")

add_executable_directory("${CMAKE_CURRENT_LIST_DIR}" "executable_a")
add_library_directory("${CMAKE_CURRENT_LIST_DIR}" "library_a")

add_executables_directory("${CMAKE_CURRENT_LIST_DIR}/executables")
add_libraries_directory("${CMAKE_CURRENT_LIST_DIR}/libraries")
add_tests_directory("${CMAKE_CURRENT_LIST_DIR}/test")
