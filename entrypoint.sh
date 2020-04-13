#!/bin/bash
set -ex

# Get inputs
URL="$1"
shift
MANIFEST="$1"
shift
GROUP="$1"
shift

# Reckon CPUs count
CPUs="$(grep processor /proc/cpuinfo | wc -l)"

# Just make sure we can write in workspace folder; and fix HOME setting
sudo chmod a+w .
export HOME=/home/user

# Launch repo initialization
repo init -u "${URL}" -m "${MANIFEST}" -g default,"${GROUP}"
.repo/repo/repo sync -j "${CPUs}"

# Prepare setup for current branch (if any)
BRANCH=`basename ${GITHUB_REF}`
if test "${BRANCH}" != "master"; then
    export MANIFEST_BRANCHES=`basename ${GITHUB_REPOSITORY}`/"${BRANCH}"
fi

# Use Makefile setup
make setup-"${GROUP}"
