#
# Load all _* files
#

import lldb
import os
import glob

def __lldb_init_module(debugger, internal_dict):
    file_path = os.path.realpath(__file__)
    dir_name = os.path.dirname(file_path)
    load_python_scripts_dir(dir_name)

def load_python_scripts_dir(dir_name):
    search_dir = os.environ['CUSTOMCFGROOT']
    pattern = os.path.join(search_dir, 'lldb', '_**')
    files = glob.glob(pattern, recursive=True)
    cmd = ''

    for file in files:
        print("=== ", file)
        if file.endswith('.py'):
            cmd = 'command script import '
        elif file.endswith('.txt'):
            cmd = 'command source -e0 -s1 '
        else:
            continue
        lldb.debugger.HandleCommand(cmd + file)

