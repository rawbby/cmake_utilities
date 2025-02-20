include_guard(GLOBAL)

include("${CMAKE_SOURCE_DIR}/.cmake_utilities/modules/structured_directories/common.cmake")

foreach (TARGET_DIR ${STATIC_DIRS})
    get_filename_component(TARGET_NAME "${TARGET_DIR}" NAME)
    add_library(${TARGET_NAME} STATIC)

    glob_source(TARGET_SRC "${TARGET_DIR}/src/")
    glob_header(TARGET_INC "${TARGET_DIR}/inc/")
    glob_header(TARGET_INCLUDE "${TARGET_DIR}/include/")

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

    include("${TARGET_DIR}/static.cmake")
    set_target_properties(${TARGET_NAME} PROPERTIES
            LINKER_LANGUAGE CXX
            CXX_STANDARD ${TARGET_CXX_STANDARD}
            CXX_STANDARD_REQUIRED ${TARGET_CXX_STANDARD_REQUIRED}
            CXX_EXTENSIONS ${TARGET_CXX_EXTENSIONS}
            INTERPROCEDURAL_OPTIMIZATION ${TARGET_INTERPROCEDURAL_OPTIMIZATION}
            RUNTIME_OUTPUT_DIRECTORY "${TARGET_RUNTIME_OUTPUT_DIRECTORY}"
            LIBRARY_OUTPUT_DIRECTORY "${TARGET_LIBRARY_OUTPUT_DIRECTORY}"
            ARCHIVE_OUTPUT_DIRECTORY "${TARGET_ARCHIVE_OUTPUT_DIRECTORY}"
            RUNTIME_INSTALL_DIRECTORY "${TARGET_RUNTIME_INSTALL_DIRECTORY}"
            LIBRARY_INSTALL_DIRECTORY "${TARGET_LIBRARY_INSTALL_DIRECTORY}"
            ARCHIVE_INSTALL_DIRECTORY "${TARGET_ARCHIVE_INSTALL_DIRECTORY}"
            INCLUDE_INSTALL_DIRECTORY "${TARGET_INCLUDE_INSTALL_DIRECTORY}")

    target_sources(${TARGET_NAME} PRIVATE ${TARGET_SRC} ${TARGET_INC})
    target_sources(${TARGET_NAME} PUBLIC ${TARGET_INCLUDE})

    if (EXISTS "${TARGET_DIR}/inc/")
        target_include_directories(${TARGET_NAME} PRIVATE "${TARGET_DIR}/inc/")
    endif ()
    if (EXISTS "${TARGET_DIR}/include/")
        target_include_directories(${TARGET_NAME} PUBLIC "${TARGET_DIR}/include/")
        install(DIRECTORY "${TARGET_DIR}/include/" DESTINATION "${TARGET_INCLUDE_INSTALL_DIRECTORY}")
    endif ()

    install(TARGETS ${TARGET_NAME}
            EXPORT ${TARGET_NAME}Targets
            RUNTIME DESTINATION "${TARGET_RUNTIME_INSTALL_DIRECTORY}"
            LIBRARY DESTINATION "${TARGET_LIBRARY_INSTALL_DIRECTORY}"
            ARCHIVE DESTINATION "${TARGET_ARCHIVE_INSTALL_DIRECTORY}")

    clang_tidy_sources(${TARGET_SRC} ${TARGET_INC} ${TARGET_INCLUDE})
    clang_format_sources(${TARGET_SRC} ${TARGET_INC} ${TARGET_INCLUDE})

    message("${PROJECT_NAME} - Added Static Library       ${TARGET_NAME}")
endforeach ()
