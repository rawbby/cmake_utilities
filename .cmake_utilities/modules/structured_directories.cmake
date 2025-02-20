include_guard(GLOBAL)

include("${CMAKE_SOURCE_DIR}/.cmake_utilities/modules/default.cmake")

get_filename_component(MODULE_NAME "${CMAKE_CURRENT_LIST_FILE}" NAME_WE)
message("${PROJECT_NAME} - Added Module               ${MODULE_NAME}")

include("${CMAKE_SOURCE_DIR}/.cmake_utilities/modules/structured_directories/common.cmake")
include("${CMAKE_SOURCE_DIR}/.cmake_utilities/modules/structured_directories/executable.cmake")
include("${CMAKE_SOURCE_DIR}/.cmake_utilities/modules/structured_directories/header.cmake")
include("${CMAKE_SOURCE_DIR}/.cmake_utilities/modules/structured_directories/shared.cmake")
include("${CMAKE_SOURCE_DIR}/.cmake_utilities/modules/structured_directories/static.cmake")
include("${CMAKE_SOURCE_DIR}/.cmake_utilities/modules/structured_directories/test.cmake")
