#!/bin/bash

# run an app in wsl2

# WSL2 notes
# Needs network tweaks in %UserProfile%/.wslconfig
#   [wsl2]
#   networkingMode=mirrored
# wsl --shutdown


export PATH=/mnt/c/builds/edge_main_systest/pub/gen/bin/l64:/mnt/c/builds/edge_main_systest/pub/gen/bin/w32:/mnt/c/builds/speechmodels_main_systest/pub/gen/bin/l64:/mnt/c/builds/speechmodels_main_systest/pub/gen/bin/w32:/mnt/c/builds/media_main_systest/pub/gen/bin/l64:/mnt/c/builds/media_main_systest/pub/gen/bin/w32:/mnt/c/builds/data_main_systest/pub/gen/bin/l64:/mnt/c/builds/data_main_systest/pub/gen/bin/w32:/mnt/c/builds/core_main_systest/pub/gen/bin/l64:/mnt/c/builds/core_main_systest/pub/gen/bin/w32:/mnt/c/builds/system_main_systest/pub/tools/common-bin:/mnt/c/builds/system_main_systest/pub/gen/bin/l64:/mnt/c/builds/system_main_systest/pub/gen/bin/w32:/mnt/c/builds/ininbuild_main_systest/pub/tools/winhost/win32/nodejs/nodejs:/mnt/c/builds/ininbuild_main_systest/pub/tools/winhost/winkits/10/bin/x64:/mnt/c/builds/ininbuild_main_systest/pub/tools/nodejs:/mnt/c/builds/ininbuild_main_systest/pub/dists/rake:/mnt/c/builds/ininbuild_main_systest/pub/tools/winhost/ninja:/mnt/c/builds/ininbuild_main_systest/pub/gen/bin/l64:/mnt/c/builds/ininbuild_main_systest/pub/gen/bin/w32:/mnt/c/builds/ininbuild_main_systest/pub/gen/bin:/mnt/c/builds/external_jdk.latest_static/pub/dists/jdk/bin:/mnt/c/builds/external_python.3.5_static/pub/tools/winhost/python:/mnt/c/builds/services_main_systest/pub/gen/bin/l64:/mnt/c/builds/services_main_systest/pub/gen/bin/w32:/mnt/c/builds/services_main_systest/pub/gen/bin:/mnt/c/builds/tools_logskim.latest_systest/pub/gen/bin/l64:/mnt/c/builds/tools_logskim.latest_systest/pub/gen/bin/w32:/mnt/c/builds/tools_logskim.latest_systest/pub/resources/golang/bin:/mnt/c/builds/corego_main_systest/pub/resources/golang/bin:/mnt/c/builds/systemgo_main_systest/pub/tools/winhost/go/bin:/mnt/c/builds/systemgo_main_systest/pub/tools/winhost/mingw64/bin:/mnt/c/builds/systemgo_main_systest/pub/resources/golang/bin:/mnt/c/builds/tools_main_systest/int/src/builds/bin:/mnt/c/builds/tools_main_systest/int/src/builds/scripts:/mnt/c/builds/tools_main_systest/utils/gnu/bin:/mnt/c/builds/tools_main_systest/utils/perl/bin:$PATH

export LD_LIBRARY_PATH=$PATH:$LD_LIBRARY_PATH

export ININ_TRACE_ROOT=/mnt/c/edge/logs
ls -l $ININ_TRACE_ROOT

clear
gen/release/l64/bin/multiproc-l64r-1-0


