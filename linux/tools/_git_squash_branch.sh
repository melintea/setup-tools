#!/bin/bash
# 
# Squash all on branch
#

if [ $# -ne 1 ]; then
    echo "Usage: $0 branch" >&2
    exit 1
fi

BRANCH=$1
git merge --squash ${BRANCH}
git commit -m "${BRANCH}: all changes"
