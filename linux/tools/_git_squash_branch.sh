#!/bin/bash
# 
# Squash all on branch
#

if [ $# -ne 1 ]; then
    echo "Usage: $0 branch" >&2
    exit 1
fi

BRANCH=$1
git checkout $BRANCH} || exit 1
git reset --soft main
git commit -m "${BRANCH}: all changes"
