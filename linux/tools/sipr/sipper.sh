#!/bin/sh -x

#
# A wrapper to run sipper from sources
#   Gateway: ./sipper.sh -c testG11AReinvite_1200_controller.rb
#   Test:    ./sipper.sh    simple_call.rb
# 

#
# Run from sources
#
##export SIPPER_HOME=/home/amelinte/work/sipr/sipper
#export SIPPER_HOME=/home/amelinte/work/sipr/sipper/sipper_ruby19
#export SRUN=${SIPPER_HOME}/bin/srun
#export SSMOKE=${SIPPER_HOME}/bin/ssmoke

#
# Run from installed gem
#
export SRUN=srun

#
# Module search path
#
#export LOAD_PATH=./ininlib:${LOAD_PATH}


touch ./.sipper.proj
${SRUN} $*

