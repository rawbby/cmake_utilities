foreach (TARGET_DIR ${EXTERN_DIRS})
    get_filename_component(TARGET_NAME "${TARGET_DIR}" NAME)

    get_property(_orig_cache_entry CACHE BUILD_TESTING PROPERTY TYPE)
    get_property(_orig_cache_value CACHE BUILD_TESTING PROPERTY VALUE)
    get_property(_orig_cache_doc CACHE BUILD_TESTING PROPERTY HELPSTRING)
    set(BUILD_TESTING OFF CACHE BOOL "Temporarily disable testing for external project" FORCE)

    set(_prev_SUPPRESS ${CMAKE_SUPPRESS_DEVELOPER_WARNINGS})
    set(CMAKE_SUPPRESS_DEVELOPER_WARNINGS 1)

    include("${TARGET_DIR}/extern.cmake")

    set(CMAKE_SUPPRESS_DEVELOPER_WARNINGS ${_prev_SUPPRESS})

    if (_orig_cache_entry)
        set(BUILD_TESTING ${_orig_cache_value} CACHE ${_orig_cache_entry} "${_orig_cache_doc}" FORCE)
    else ()
        unset(BUILD_TESTING CACHE)
    endif ()

    message("${PROJECT_NAME} - Added External Dependency  ${TARGET_NAME}")
endforeach ()
