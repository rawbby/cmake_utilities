include_guard(GLOBAL)

include("${CMAKE_SOURCE_DIR}/.cmake_utilities/modules/structured_directories/common.cmake")

block()
    foreach (TARGET_DIR ${SHARED_DIRS})
        block()
            get_filename_component(TARGET_NAME "${TARGET_DIR}" NAME)
            set(TARGET_NAME_USC "${TARGET_NAME}")
            string(REGEX MATCH "[a-z]" "${TARGET_NAME_USC}" CONTAINS_LOWER)
            if (CONTAINS_LOWER)
                string(REGEX REPLACE "([A-Z])" "_\\1" TARGET_NAME_USC "${TARGET_NAME_USC}")
            endif ()
            string(REGEX REPLACE "[^A-Za-z0-9]+" "_" TARGET_NAME_USC "${TARGET_NAME_USC}")
            string(REGEX REPLACE "_+" "_" TARGET_NAME_USC "${TARGET_NAME_USC}")
            string(REGEX REPLACE "^_+" "" TARGET_NAME_USC "${TARGET_NAME_USC}")
            string(TOUPPER "${TARGET_NAME_USC}" TARGET_NAME_USC)

            add_library(${TARGET_NAME} SHARED)

            glob_sources(TARGET_SRC "${TARGET_DIR}/src/")

            set(TARGET_CXX_STANDARD ${CMAKE_CXX_STANDARD})
            set(TARGET_CXX_STANDARD_REQUIRED ${CMAKE_CXX_STANDARD_REQUIRED})
            set(TARGET_CXX_EXTENSIONS ${CMAKE_CXX_EXTENSIONS})
            set(TARGET_INTERPROCEDURAL_OPTIMIZATION ${CMAKE_INTERPROCEDURAL_OPTIMIZATION})
            set(TARGET_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
            set(TARGET_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")
            set(TARGET_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}")
            set(TARGET_RUNTIME_INSTALL_DIRECTORY "${CMAKE_RUNTIME_INSTALL_DIRECTORY}")
            set(TARGET_LIBRARY_INSTALL_DIRECTORY "${CMAKE_LIBRARY_INSTALL_DIRECTORY}")
            set(TARGET_ARCHIVE_INSTALL_DIRECTORY "${CMAKE_ARCHIVE_INSTALL_DIRECTORY}")
            set(TARGET_INCLUDE_INSTALL_DIRECTORY "${CMAKE_INCLUDE_INSTALL_DIRECTORY}")

            configure_file(
                    "${CMAKE_SOURCE_DIR}/.cmake_utilities/modules/structured_directories/export.h.in"
                    "${CMAKE_CURRENT_BINARY_DIR}/${TARGET_NAME}/include/${TARGET_NAME}_export.h"
                    @ONLY)

            include("${TARGET_DIR}/shared.cmake")
            set_target_properties(${TARGET_NAME} PROPERTIES
                    LINKER_LANGUAGE CXX
                    CXX_STANDARD ${TARGET_CXX_STANDARD}
                    CXX_STANDARD_REQUIRED ${TARGET_CXX_STANDARD_REQUIRED}
                    CXX_EXTENSIONS ${TARGET_CXX_EXTENSIONS}
                    POSITION_INDEPENDENT_CODE ON
                    INTERPROCEDURAL_OPTIMIZATION ${TARGET_INTERPROCEDURAL_OPTIMIZATION}
                    RUNTIME_OUTPUT_DIRECTORY "${TARGET_RUNTIME_OUTPUT_DIRECTORY}"
                    LIBRARY_OUTPUT_DIRECTORY "${TARGET_LIBRARY_OUTPUT_DIRECTORY}"
                    ARCHIVE_OUTPUT_DIRECTORY "${TARGET_ARCHIVE_OUTPUT_DIRECTORY}"
                    RUNTIME_INSTALL_DIRECTORY "${TARGET_RUNTIME_INSTALL_DIRECTORY}"
                    LIBRARY_INSTALL_DIRECTORY "${TARGET_LIBRARY_INSTALL_DIRECTORY}"
                    ARCHIVE_INSTALL_DIRECTORY "${TARGET_ARCHIVE_INSTALL_DIRECTORY}"
                    INCLUDE_INSTALL_DIRECTORY "${TARGET_INCLUDE_INSTALL_DIRECTORY}")

            target_sources(${TARGET_NAME} PRIVATE ${TARGET_SRC})
            target_include_directories(${TARGET_NAME} PRIVATE "${TARGET_DIR}/inc/")
            target_include_directories(${TARGET_NAME} PUBLIC "${TARGET_DIR}/include/")
            target_include_directories(${TARGET_NAME}
                    PUBLIC
                    $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/${TARGET_NAME}/include/>
                    $<INSTALL_INTERFACE:${TARGET_INCLUDE_INSTALL_DIRECTORY}>)
            target_compile_definitions(${TARGET_NAME} PRIVATE "${TARGET_NAME_USC}_EXPORTS")

            install(TARGETS ${TARGET_NAME}
                    EXPORT ${TARGET_NAME}Targets
                    RUNTIME DESTINATION "${TARGET_RUNTIME_INSTALL_DIRECTORY}"
                    LIBRARY DESTINATION "${TARGET_LIBRARY_INSTALL_DIRECTORY}"
                    ARCHIVE DESTINATION "${TARGET_ARCHIVE_INSTALL_DIRECTORY}")
            install(DIRECTORY "${TARGET_DIR}/include/" DESTINATION "${TARGET_INCLUDE_INSTALL_DIRECTORY}")
            install(DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/${TARGET_NAME}/include/" DESTINATION "${TARGET_INCLUDE_INSTALL_DIRECTORY}")

            clang_tidy_sources(${TARGET_SRC} ${TARGET_SOURCE} ${TARGET_INC} ${TARGET_INCLUDE})
            clang_format_sources(${TARGET_SRC} ${TARGET_SOURCE} ${TARGET_INC} ${TARGET_INCLUDE})

            message("${PROJECT_NAME} - Added Shared Library       ${TARGET_NAME}")
        endblock()
    endforeach ()
endblock()
