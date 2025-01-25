include_guard(GLOBAL)

function(file_glob_source OUT_VAR BASE_DIR)
    file(GLOB_RECURSE _TMP
            "${BASE_DIR}/*.c"
            "${BASE_DIR}/*.cc"
            "${BASE_DIR}/*.cp"
            "${BASE_DIR}/*.cpp"
            "${BASE_DIR}/*.cxx")
    if (NOT DEFINED ${OUT_VAR})
        set(${OUT_VAR})
    endif ()
    list(APPEND ${OUT_VAR} ${_TMP})
    set(${OUT_VAR} ${${OUT_VAR}} PARENT_SCOPE)
endfunction()

function(file_glob_header OUT_VAR BASE_DIR)
    file(GLOB_RECURSE _TMP
            "${BASE_DIR}/*.h"
            "${BASE_DIR}/*.hh"
            "${BASE_DIR}/*.hp"
            "${BASE_DIR}/*.hpp"
            "${BASE_DIR}/*.hxx")
    if (NOT DEFINED ${OUT_VAR})
        set(${OUT_VAR})
    endif ()
    list(APPEND ${OUT_VAR} ${_TMP})
    set(${OUT_VAR} ${${OUT_VAR}} PARENT_SCOPE)
endfunction()
