foreach (TARGET_DIR ${EXTERN_DIRS})
    get_filename_component(TARGET_NAME "${TARGET_DIR}" NAME)

    get_property(_orig_bt_entry CACHE BUILD_TESTING PROPERTY TYPE)
    get_property(_orig_bt_value CACHE BUILD_TESTING PROPERTY VALUE)
    get_property(_orig_bt_doc CACHE BUILD_TESTING PROPERTY HELPSTRING)
    set(BUILD_TESTING OFF CACHE BOOL "Temporarily disable testing for extern" FORCE)

    get_property(_orig_sdw_type CACHE CMAKE_SUPPRESS_DEVELOPER_WARNINGS PROPERTY TYPE)
    get_property(_orig_sdw_value CACHE CMAKE_SUPPRESS_DEVELOPER_WARNINGS PROPERTY VALUE)
    get_property(_orig_sdw_doc CACHE CMAKE_SUPPRESS_DEVELOPER_WARNINGS PROPERTY HELPSTRING)
    set(CMAKE_SUPPRESS_DEVELOPER_WARNINGS 1 CACHE INTERNAL "Temporarily suppress dev warnings for extern" FORCE)

    include("${TARGET_DIR}/extern.cmake")

    if (_orig_sdw_type)
        set(CMAKE_SUPPRESS_DEVELOPER_WARNINGS ${_orig_sdw_value} CACHE ${_orig_sdw_type} "${_orig_sdw_doc}" FORCE)
    else ()
        unset(CMAKE_SUPPRESS_DEVELOPER_WARNINGS CACHE)
    endif ()

    if (_orig_bt_entry)
        set(BUILD_TESTING ${_orig_bt_value} CACHE ${_orig_bt_entry} "${_orig_bt_doc}" FORCE)
    else ()
        unset(BUILD_TESTING CACHE)
    endif ()

    message("${PROJECT_NAME} - Added External Dependency  ${TARGET_NAME}")
endforeach ()
