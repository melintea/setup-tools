#!/usr/bin/bash

#
# Gflags setup script
#

#GFLAGS_U=`cygpath 'C:\Program Files (x86)\Windows Kits\10\Debuggers\x64\gflags.exe'`
GFLAGS_U=`cygpath 'C:\Program Files (x86)\Windows Kits\8.1\Debuggers\x64\gflags.exe'`


#CDB_U=`cygpath 'C:\Program Files (x86)\Windows Kits\10\Debuggers\x64\cdb.exe'`
CDB_U=`cygpath 'C:\Program Files (x86)\Windows Kits\8.1\Debuggers\x64\cdb.exe'`


#CDB_CMD_W='C:\Program Files (x86)\Windows Kits\10\Debuggers\x64\_cdb.cmd'
CDB_CMD_W='C:\Program Files (x86)\Windows Kits\8.1\Debuggers\x64\_cdb.cmd'


# Sample usage:
#    set_gflags  test_bridgeserver-w64d-1-0.exe 
function set_gflags()
{
    EXE_IMG="$1"
    # "${GFLAGS_U}" /p /disable "${EXE_IMG}" 
    "${GFLAGS_U}" /p /enable "${EXE_IMG}" /full /tracedb 100 /debug "${CDB_CMD_W}" 
}


set_gflags  crashme.exe

