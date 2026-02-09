#
# Load all _* scripts
#

import os
import glob

current_directory = os.getcwd()
print(current_directory)

# Directory to search for .gdbinit files
# Use '.' for the current directory or specify an absolute path
search_dir = os.environ['CUSTOMCFGROOT']
pattern = os.path.join(search_dir, 'gdb', '_**')
files = glob.glob(pattern, recursive=True)

for file in files:
    print("=== ", file)
    # Use GDB's "source" command for each file found
    gdb.execute(f'source {file}')

