foreach (TARGET_DIR ${EXTERN_DIRS})
    get_filename_component(TARGET_NAME "${TARGET_DIR}" NAME)

    get_property(_orig_bt_entry CACHE BUILD_TESTING PROPERTY TYPE)
    get_property(_orig_bt_value CACHE BUILD_TESTING PROPERTY VALUE)
    get_property(_orig_bt_doc CACHE BUILD_TESTING PROPERTY HELPSTRING)
    set(BUILD_TESTING OFF CACHE BOOL "Temporarily disable testing for extern" FORCE)

    get_property(_orig_ll_type CACHE CMAKE_MESSAGE_LOG_LEVEL PROPERTY TYPE)
    get_property(_orig_ll_value CACHE CMAKE_MESSAGE_LOG_LEVEL PROPERTY VALUE)
    get_property(_orig_ll_doc CACHE CMAKE_MESSAGE_LOG_LEVEL PROPERTY HELPSTRING)
    set(CMAKE_MESSAGE_LOG_LEVEL ERROR CACHE INTERNAL "Temporarily print errors only for extern" FORCE)

    include("${TARGET_DIR}/extern.cmake")

    if (_orig_ll_type)
        set(CMAKE_MESSAGE_LOG_LEVEL ${_orig_ll_value} CACHE ${_orig_ll_type} "${_orig_ll_doc}" FORCE)
    else ()
        unset(CMAKE_MESSAGE_LOG_LEVEL CACHE)
    endif ()

    if (_orig_bt_entry)
        set(BUILD_TESTING ${_orig_bt_value} CACHE ${_orig_bt_entry} "${_orig_bt_doc}" FORCE)
    else ()
        unset(BUILD_TESTING CACHE)
    endif ()

    message("${PROJECT_NAME} - Added External Dependency  ${TARGET_NAME}")
endforeach ()
