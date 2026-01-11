set(TARGET_COMMAND $<TARGET_FILE:${TARGET_NAME}> -e)

add_dependencies(${TARGET_NAME} clang_format clang_tidy)
