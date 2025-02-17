#!/bin/python3

import os
import sys
from os.path import join, abspath
from pathlib import Path

if os.name == 'nt':
    import msvcrt
else:
    import fcntl


class FileLock:
    def __init__(self, filename: str):
        self.filename: str = filename

    def __enter__(self):
        self.fp = open(self.filename, 'wb')
        if os.name == 'nt':
            self.fp.seek(0)
            msvcrt.locking(self.fp.fileno(), msvcrt.LK_LOCK, 1)
        else:
            fcntl.flock(self.fp.fileno(), fcntl.LOCK_EX)

    def __exit__(self, _type, value, tb):
        if os.name == 'nt':
            self.fp.seek(0)
            msvcrt.locking(self.fp.fileno(), msvcrt.LK_UNLCK, 1)
        else:
            fcntl.flock(self.fp.fileno(), fcntl.LOCK_UN)
        self.fp.close()


def lock_venv():
    venv_path = abspath(join(os.getcwd(), '.venv'))
    os.makedirs(venv_path, exist_ok=True)
    return FileLock(join(venv_path, '.lock'))


def run(command: [str], cwd=None) -> str:
    from subprocess import Popen, PIPE, STDOUT

    cwd = cwd if cwd is not None else join(os.getcwd())

    print(' '.join(command), flush=True)
    process = Popen(command, stdout=PIPE, stderr=STDOUT, text=True, cwd=cwd)
    stdout = ''
    for stdout_line in iter(process.stdout.readline, ''):
        stdout += stdout_line
        print(stdout_line, end='', flush=True)
    process.stdout.close()
    status = process.wait()
    if status:
        sys.exit(status)
    return stdout


def bootstrap():
    venv_path = abspath(join(os.getcwd(), '.venv'))
    valid_file = Path(join(venv_path, '.valid'))

    if os.name == 'nt':
        venv_executable = join(venv_path, 'Scripts', 'python.exe')
    else:
        venv_executable = join(venv_path, 'bin', 'python')

    if not valid_file.exists():
        with lock_venv():
            if not valid_file.exists():
                run([sys.executable, '-m', 'venv', '.venv'])
                run([venv_executable, '-m', 'ensurepip', '--upgrade'])
                valid_file.touch()


if __name__ == '__main__':
    bootstrap()
