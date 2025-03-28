if (BUILD_TESTING)
    enable_testing()
    foreach (TEST_DIR ${TEST_DIRS})

        glob_source(TEST_FILES ${TEST_DIR})

        foreach (TARGET_SRC ${TEST_FILES})
            get_filename_component(TARGET_NAME "${TARGET_SRC}" NAME_WE)
            add_executable(${TARGET_NAME} ${TARGET_SRC})

            set(TARGET_CLANG_FORMAT_AUTO_SOURCE ${CLANG_FORMAT_AUTO_SOURCE})
            set(TARGET_CLANG_TIDY_AUTO_SOURCE ${CLANG_TIDY_AUTO_SOURCE})

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

            include("${TEST_DIR}/tests.cmake")
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

            install(TARGETS ${TARGET_NAME}
                    EXPORT ${TARGET_NAME}Targets
                    RUNTIME DESTINATION "${TARGET_RUNTIME_INSTALL_DIRECTORY}"
                    LIBRARY DESTINATION "${TARGET_LIBRARY_INSTALL_DIRECTORY}"
                    ARCHIVE DESTINATION "${TARGET_ARCHIVE_INSTALL_DIRECTORY}")

            if (${TARGET_CLANG_TIDY_AUTO_SOURCE})
                clang_tidy_sources(${TARGET_SRC})
            endif ()
            if (${TARGET_CLANG_FORMAT_AUTO_SOURCE})
                clang_format_sources(${TARGET_SRC})
            endif ()

            add_test(NAME "${TARGET_NAME}" COMMAND $<TARGET_FILE:${TARGET_NAME}>)
            message("${PROJECT_NAME} - Added Test                 ${TARGET_NAME}")
        endforeach ()
    endforeach ()
endif ()
