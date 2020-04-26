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
repo init -u "${URL}" -m "${MANIFEST}" -g default,"${GROUP}" --depth=1
.repo/repo/repo sync -j "${CPUs}"

# Prepare some environment
export CI=1
export CI_PROJECT=`basename ${GITHUB_REPOSITORY}`
if echo "${GITHUB_REF}" | grep "refs/tags/" >/dev/null; then
    # Prepare setup for current tag
    export CI_TAG=`basename ${GITHUB_REF}`
    export MANIFEST_TAGS="${CI_PROJECT}"/"${CI_TAG}"
else
    # Prepare setup for current branch (if not master)
    export CI_BRANCH=`basename ${GITHUB_REF}`
    if test "${CI_BRANCH}" != "master"; then
        export MANIFEST_BRANCHES="${CI_PROJECT}"/"${CI_BRANCH}"
    fi
fi

# Use Makefile setup
make setup-"${GROUP}"
