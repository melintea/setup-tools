#!/bin/bash

#
# Modified Gittyup/pack/buildUbuntu.sh
#

pwd

pushd /opt
sudo mkdir gittyup && sudo chmod a+rw gittyup
popd #cwd

git clone --depth 1 https://github.com/Murmele/Gittyup
pushd Gittyup/pack

sudo apt install build-essential libgl1-mesa-dev
sudo apt install cmake
sudo apt install libgit2-dev
sudo apt install cmark
sudo apt install git
sudo apt install libssh2-1-dev
sudo apt install openssl
sudo apt install qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools
sudo apt install qttools5-dev
sudo apt install ninja-build

pushd ..  #Gittyup
git fetch
git submodule init
git submodule update
git pull
git checkout deps
pushd dep/openssl/openssl/
./config -fPIC
make
popd  #Gittyup

mkdir -vp build/release
pushd build/release
cmake -G Ninja -DCMAKE_BUILD_TYPE=Release  -DCMAKE_INSTALL_PREFIX=/opt/gittyup ../..
cmake --build . --config Release --target install

popd #cwd

