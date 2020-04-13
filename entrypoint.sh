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

# Just make sure we can write in workspace folder
sudo chmod a+w .

# Launch repo initialization
repo init -u "${URL}" -m "${MANIFEST}" -g default,"${GROUP}"
.repo/repo/repo sync -j "${CPUs}"

# Prepare setup for current branch
export MANIFEST_BRANCHES=`basename ${GITHUB_REPOSITORY}`/`basename ${GITHUB_REF}`
make setup-"${GROUP}"
