#!/bin/bash

# discard uncommited changes to file

git restore "$*"

# v < 2.23
# git checkout -- "$*"

# older version
# git checkout hash -- file

