include_guard(GLOBAL)

if (WIN32)
    find_program(PYTHON_EXECUTABLE NAMES python.exe python)
    set(VENV_PYTHON_EXECUTABLE "${CMAKE_SOURCE_DIR}/.venv/Scripts/python.exe")
else ()
    find_program(PYTHON_EXECUTABLE NAMES python3 python)
    set(VENV_PYTHON_EXECUTABLE "${CMAKE_SOURCE_DIR}/.venv/bin/python")
endif ()

function(bootstrap_python)
    message("${PYTHON_EXECUTABLE} ${CMAKE_SOURCE_DIR}/.cmake_utilities/bootstrap.py")
    execute_process(COMMAND "${PYTHON_EXECUTABLE}" "${CMAKE_SOURCE_DIR}/.cmake_utilities/bootstrap.py"
            WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
            RESULT_VARIABLE PROCESS_RESULT
            ERROR_VARIABLE PROCESS_ERROR)

    if (NOT ${PROCESS_ERROR} EQUAL 0)
        string(REGEX REPLACE "." " " WHITESPACE ${PROJECT_NAME})
        message(FATAL_ERROR
                "${PROJECT_NAME} - Executing Process failed with Exit Code ${PROCESS_RESULT}:\n"
                "${WHITESPACE} - ${PYTHON_EXE} ${CMAKE_SOURCE_DIR}/.cmake_utilities/bootstrap.py\n"
                "${WHITESPACE} - Python Error:\n${PROCESS_ERROR}")
    endif ()
endfunction()

function(execute_python)
    if (ARGC EQUAL 0)
        message(WARNING "execute_python ignored as no parameter was passed")

    else ()
        message("${VENV_PYTHON_EXECUTABLE} ${ARGN}")
        execute_process(COMMAND "${VENV_PYTHON_EXECUTABLE}" ${ARGN}
                WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
                RESULT_VARIABLE PROCESS_RESULT
                ERROR_VARIABLE PROCESS_ERROR)

        if (NOT ${PROCESS_ERROR} EQUAL 0)
            string(REGEX REPLACE "." " " WHITESPACE ${PROJECT_NAME})
            message(FATAL_ERROR
                    "${PROJECT_NAME} - Executing Python failed with Exit Code ${PROCESS_RESULT}:\n"
                    "${WHITESPACE} - Python Error:\n${PROCESS_ERROR}")
        endif ()

    endif ()
endfunction()
