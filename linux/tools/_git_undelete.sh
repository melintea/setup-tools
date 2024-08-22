#!/bin/bash

# get back accidentally removed files


# To recover all unstaged deletions 
git ls-files -z -d | xargs -0 git checkout --

# To recover all staged deletions
git status | grep 'deleted:' | awk '{print $2}' | xargs git checkout --

