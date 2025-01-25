include_guard(GLOBAL)

macro(bootstrap_python)

    if (DEFINED Python_EXECUTABLE)
        set(PYTHON_EXECUTABLE "${Python_EXECUTABLE}")
    endif ()

    if (DEFINED Python3_EXECUTABLE)
        set(PYTHON_EXECUTABLE "${Python3_EXECUTABLE}")
    endif ()

    if (NOT DEFINED PYTHON_EXECUTABLE)
        if (WIN32)
            set(PYTHON_EXECUTABLE python.exe)
        else ()
            set(PYTHON_EXECUTABLE python3)
        endif ()
    endif ()

    if (WIN32)
        set(VENV_PYTHON_EXECUTABLE "${CMAKE_SOURCE_DIR}/.venv/Scripts/python.exe")
    else ()
        set(VENV_PYTHON_EXECUTABLE "${CMAKE_SOURCE_DIR}/.venv/bin/python")
    endif ()

    block()
        execute_process(COMMAND "${PYTHON_EXE}" "${CMAKE_SOURCE_DIR}/.cmake_utilities/bootstrap.py"
                WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
                RESULT_VARIABLE PROCESS_RESULT
                OUTPUT_VARIABLE PROCESS_OUTPUT
                ERROR_VARIABLE PROCESS_ERROR)

        if (NOT ${PROCESS_ERROR} EQUAL 0)
            string(REGEX REPLACE "." " " WHITESPACE ${PROJECT_NAME})
            message(FATAL_ERROR
                    "${PROJECT_NAME} - Executing Process failed with Exit Code ${PROCESS_RESULT}:\n"
                    "${WHITESPACE} - ${PYTHON_EXE} ${CMAKE_SOURCE_DIR}/.cmake_utilities/bootstrap.py\n"
                    "${WHITESPACE} - ${PROCESS_ERROR}\n"
                    "${WHITESPACE} - Process Output:\n${PROCESS_OUTPUT}")
        endif ()
    endblock()
endmacro()

function(execute_python)
    if (ARGC EQUAL 0)
        message(WARNING "execute_python ignored as no parameter was passed")
    else ()
        execute_process(COMMAND "${VENV_PYTHON_EXECUTABLE}" ${ARGN}
                WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
                RESULT_VARIABLE PROCESS_RESULT
                OUTPUT_VARIABLE PROCESS_OUTPUT
                ERROR_VARIABLE PROCESS_ERROR)

        if (NOT ${PROCESS_ERROR} EQUAL 0)
            string(REGEX REPLACE "." " " WHITESPACE ${PROJECT_NAME})
            message(FATAL_ERROR
                    "${PROJECT_NAME} - Executing Python failed with Exit Code ${PROCESS_RESULT}:\n"
                    "${WHITESPACE} - ${VENV_PYTHON_EXECUTABLE} ${ARGN}\n"
                    "${WHITESPACE} - ${PROCESS_ERROR}\n"
                    "${WHITESPACE} - Python Output:\n${PROCESS_OUTPUT}")
        endif ()

    endif ()
endfunction()
