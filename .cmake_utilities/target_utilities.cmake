include_guard(GLOBAL)

include("${CMAKE_SOURCE_DIR}/.cmake_utilities/defaults.cmake")
include("${CMAKE_SOURCE_DIR}/.cmake_utilities/glob.cmake")

macro(default_target_properties)

    if (NOT DEFINED TARGET_NAME)
        message(FATAL_ERROR "default_target_properties needs TARGET_NAME to be set")
    endif ()

    if (NOT DEFINED TARGET_CXX_STANDARD)
        set(TARGET_CXX_STANDARD "${CMAKE_CXX_STANDARD}")
    endif ()

    if (NOT DEFINED TARGET_CXX_STANDARD_REQUIRED)
        set(TARGET_CXX_STANDARD_REQUIRED "${CMAKE_CXX_STANDARD_REQUIRED}")
    endif ()

    if (NOT DEFINED TARGET_CXX_EXTENSIONS)
        set(TARGET_CXX_EXTENSIONS "${CMAKE_CXX_EXTENSIONS}")
    endif ()

    if (NOT DEFINED TARGET_RUNTIME_OUTPUT_DIRECTORY)
        set(TARGET_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
    endif ()

    if (NOT DEFINED TARGET_LIBRARY_OUTPUT_DIRECTORY)
        set(TARGET_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")
    endif ()

    if (NOT DEFINED TARGET_ARCHIVE_OUTPUT_DIRECTORY)
        set(TARGET_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}")
    endif ()

    set_target_properties(${TARGET_NAME} PROPERTIES
            LINKER_LANGUAGE CXX
            CXX_STANDARD ${TARGET_CXX_STANDARD}
            CXX_STANDARD_REQUIRED ${TARGET_CXX_STANDARD_REQUIRED}
            CXX_EXTENSIONS ${TARGET_CXX_EXTENSIONS}
            RUNTIME_OUTPUT_DIRECTORY "${TARGET_RUNTIME_OUTPUT_DIRECTORY}"
            LIBRARY_OUTPUT_DIRECTORY "${TARGET_LIBRARY_OUTPUT_DIRECTORY}"
            ARCHIVE_OUTPUT_DIRECTORY "${TARGET_ARCHIVE_OUTPUT_DIRECTORY}")

endmacro()

macro(default_target_sources)

    if (NOT DEFINED TARGET_NAME)
        message(FATAL_ERROR "default_target_sources needs TARGET_NAME to be set")
    endif ()

    if (DEFINED TARGET_SRC)
        if (NOT "${TARGET_SRC}" STREQUAL "")
            target_sources(${TARGET_NAME} PRIVATE ${TARGET_SRC})
        endif ()
    endif ()

    if (DEFINED TARGET_SOURCE)
        if (NOT "${TARGET_SOURCE}" STREQUAL "")
            target_sources(${TARGET_NAME} PRIVATE ${TARGET_SOURCE})
        endif ()
    endif ()

    if (DEFINED TARGET_INC)
        if (NOT "${TARGET_INC}" STREQUAL "")
            target_sources(${TARGET_NAME} PRIVATE ${TARGET_INC})
            target_include_directories(${TARGET_NAME} PRIVATE "${TARGET_DIR}/inc/")
        endif ()
    endif ()

    if (DEFINED TARGET_INCLUDE)
        if (NOT "${TARGET_INCLUDE}" STREQUAL "")
            get_target_property(TARGET_TYPE ${TARGET_NAME} TYPE)
            if (TARGET_TYPE STREQUAL "INTERFACE_LIBRARY")
                target_sources(${TARGET_NAME} INTERFACE ${TARGET_INCLUDE})
                target_include_directories(${TARGET_NAME} INTERFACE "${TARGET_DIR}/include/")
            elseif (TARGET_TYPE STREQUAL "EXECUTABLE")
                target_sources(${TARGET_NAME} PRIVATE ${TARGET_INCLUDE})
                target_include_directories(${TARGET_NAME} PRIVATE "${TARGET_DIR}/include/")
            else ()
                target_sources(${TARGET_NAME} PUBLIC ${TARGET_INCLUDE})
                target_include_directories(${TARGET_NAME} PUBLIC "${TARGET_DIR}/include/")
            endif ()
        endif ()
    endif ()

endmacro()

macro(default_target_install)

    if (NOT DEFINED TARGET_NAME)
        message(FATAL_ERROR "default_target_install needs TARGET_NAME to be set")
    endif ()

    if (NOT DEFINED TARGET_RUNTIME_INSTALL_DIRECTORY)
        set(TARGET_RUNTIME_INSTALL_DIRECTORY "${CMAKE_RUNTIME_INSTALL_DIRECTORY}")
    endif ()

    if (NOT DEFINED TARGET_LIBRARY_INSTALL_DIRECTORY)
        set(TARGET_LIBRARY_INSTALL_DIRECTORY "${CMAKE_LIBRARY_INSTALL_DIRECTORY}")
    endif ()

    if (NOT DEFINED TARGET_ARCHIVE_INSTALL_DIRECTORY)
        set(TARGET_ARCHIVE_INSTALL_DIRECTORY "${CMAKE_ARCHIVE_INSTALL_DIRECTORY}")
    endif ()

    if (NOT DEFINED TARGET_INCLUDE_INSTALL_DIRECTORY)
        set(TARGET_INCLUDE_INSTALL_DIRECTORY "${CMAKE_INCLUDE_INSTALL_DIRECTORY}")
    endif ()

    install(TARGETS ${TARGET_NAME}
            EXPORT ${TARGET_NAME}Targets
            RUNTIME DESTINATION "${TARGET_RUNTIME_INSTALL_DIRECTORY}"
            LIBRARY DESTINATION "${TARGET_LIBRARY_INSTALL_DIRECTORY}"
            ARCHIVE DESTINATION "${TARGET_ARCHIVE_INSTALL_DIRECTORY}")

    if (DEFINED TARGET_INCLUDE)
        if (NOT "${TARGET_INCLUDE}" STREQUAL "")
            install(DIRECTORY "${TARGET_DIR}/include/" DESTINATION "${TARGET_INCLUDE_INSTALL_DIRECTORY}")
        endif ()
    endif ()

endmacro()

macro(default_shared_configuration)

    if (NOT DEFINED TARGET_NAME)
        message(FATAL_ERROR "default_shared_configuration needs TARGET_NAME to be set")
    endif ()

    if (NOT DEFINED TARGET_INCLUDE_INSTALL_DIRECTORY)
        set(TARGET_INCLUDE_INSTALL_DIRECTORY "${CMAKE_INCLUDE_INSTALL_DIRECTORY}")
    endif ()

    block()
        upper_snake_case(TARGET_NAME_USC "${TARGET_NAME}")
        set(TARGET_EXPORT_FILE_NAME "${TARGET_NAME}_export.h")
        configure_file(
                "${CMAKE_SOURCE_DIR}/.cmake_utilities/export.h.in"
                "${CMAKE_CURRENT_BINARY_DIR}/${TARGET_NAME}/include/${TARGET_EXPORT_FILE_NAME}"
                @ONLY)
        target_include_directories(${TARGET_NAME}
                PUBLIC
                $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/${TARGET_NAME}/include/>
                $<INSTALL_INTERFACE:${TARGET_INCLUDE_INSTALL_DIRECTORY}>)
        set_target_properties(${TARGET_NAME} PROPERTIES
                POSITION_INDEPENDENT_CODE ON)
        target_compile_definitions(${TARGET_NAME} PRIVATE
                "${TARGET_NAME_USC}_EXPORTS")
        install(DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/${TARGET_NAME}/include/" DESTINATION "${TARGET_INCLUDE_INSTALL_DIRECTORY}")
    endblock()

endmacro()

macro(default_glob_sources)

    if (NOT DEFINED TARGET_DIR)
        message(FATAL_ERROR "default_glob_sources needs TARGET_DIR to be set")
    endif ()

    file_glob_source(TARGET_SRC "${TARGET_DIR}/src")
    file_glob_header(TARGET_SRC "${TARGET_DIR}/src")
    file_glob_source(TARGET_SOURCE "${TARGET_DIR}/source")
    file_glob_header(TARGET_SOURCE "${TARGET_DIR}/source")
    file_glob_header(TARGET_INC "${TARGET_DIR}/inc")
    file_glob_header(TARGET_INCLUDE "${TARGET_DIR}/include")

    if ("${TARGET_SRC}" STREQUAL "")
        unset(TARGET_SRC)
    endif ()

    if ("${TARGET_SOURCE}" STREQUAL "")
        unset(TARGET_SOURCE)
    endif ()

    if ("${TARGET_INC}" STREQUAL "")
        unset(TARGET_INC)
    endif ()

    if ("${TARGET_INCLUDE}" STREQUAL "")
        unset(TARGET_INCLUDE)
    endif ()

endmacro()
