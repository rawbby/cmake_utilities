target_link_libraries(${TARGET_NAME} PRIVATE header_lib)
target_link_libraries(${TARGET_NAME} PRIVATE shared_lib)
target_link_libraries(${TARGET_NAME} PRIVATE static_lib)
add_dependencies(${TARGET_NAME} clang_format clang_tidy)
