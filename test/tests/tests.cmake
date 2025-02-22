if (TARGET_NAME STREQUAL "test_header")
    target_link_libraries(${TARGET_NAME} PRIVATE header_lib)
endif ()

if (TARGET_NAME STREQUAL "test_shared")
    target_link_libraries(${TARGET_NAME} PRIVATE shared_lib)
endif ()

if (TARGET_NAME STREQUAL "test_static")
    target_link_libraries(${TARGET_NAME} PRIVATE static_lib)
endif ()

if (TARGET_NAME STREQUAL "test_all")
    target_link_libraries(${TARGET_NAME} PRIVATE header_lib)
    target_link_libraries(${TARGET_NAME} PRIVATE shared_lib)
    target_link_libraries(${TARGET_NAME} PRIVATE static_lib)
endif ()
