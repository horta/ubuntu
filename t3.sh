#!/bin/bash

. ~/anaconda/etc/profile.d/conda.sh
conda activate base

export PRJ_NAME=$1
export PKG_NAME=$2
export PRJ_NAME_CLONE=${PRJ_NAME}_clone
export TRAVIS_BUILD_DIR=/home/horta/code/$PRJ_NAME_CLONE

mkdir code && cd code
git clone --depth=5 file:///home/horta/host/$PRJ_NAME/.git $PRJ_NAME_CLONE
pwd && ls && cd $PRJ_NAME_CLONE
conda create -n py36 python=3.6 -y
conda activate py36
bash <(curl -fsSL https://raw.githubusercontent.com/horta/ci/master/travis.sh)
