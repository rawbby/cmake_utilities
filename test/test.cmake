include("${CMAKE_SOURCE_DIR}/bootstrap.cmake")
include("${CMAKE_SOURCE_DIR}/.cmake_utilities/all.cmake")

add_executable_directory("${CMAKE_SOURCE_DIR}/test" "executable_a")
add_library_directory("${CMAKE_SOURCE_DIR}/test" "library_a")
add_executables_directory("${CMAKE_SOURCE_DIR}/test/executables")
add_libraries_directory("${CMAKE_SOURCE_DIR}/test/libraries")
add_tests_directory("${CMAKE_SOURCE_DIR}/test/test")
