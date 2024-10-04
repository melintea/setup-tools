#!/bin/bash

git reflog
read -p "Last commit to keep: " commit

git reset --soft ${commit}
git commit -m 'Squash irrelevant commits'
git push --force origin main
