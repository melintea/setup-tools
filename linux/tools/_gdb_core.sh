#!/usr/bin/sh

#
# Use: script core
#

FOLDER=`pwd`
EXECUTABLE1=`file $1  | cut -d ' ' -f 28 | cut -c 3-`
EXECUTABLE=${EXECUTABLE1::-2} # Bash only, cut last two chars ',
echo "$1 => ${EXECUTABLE}"

#    -iex "set auto-load safe-path /" \
/opt/rh/devtoolset-7/root/usr/bin/gdb \
    -iex "set logging file _gdb.$1.log" -iex "set logging on" \
    -iex "set solib-absolute-prefix ${FOLDER}"  \
    ${FOLDER}/${EXECUTABLE} \
    $*

