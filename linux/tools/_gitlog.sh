#!/bin/bash

#git log --graph --decorate --oneline $*
git log  --pretty=format:'%C(yellow)%h %Cred%ad %Cblue%an%Cgreen%d %Creset%s' --date=short  

