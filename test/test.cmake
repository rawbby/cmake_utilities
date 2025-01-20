set(CMAKE_UTILITIES_VERSION "main" CACHE STRING "")

if (NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/.cmake_utilities/.valid")
    file(DOWNLOAD "https://raw.githubusercontent.com/rawbby/cmake_utilities/${CMAKE_UTILITIES_VERSION}/bootstrap.cmake"
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
