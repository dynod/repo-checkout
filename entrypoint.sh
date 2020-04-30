#!/bin/bash
set -ex

# Get inputs
URL="$1"
shift
MANIFEST="$1"
shift
GROUP="$1"
shift
ENVVARS="$1"
shift

# Reckon CPUs count
CPUs="$(grep processor /proc/cpuinfo | wc -l)"

# Just make sure we can write in workspace folder; and fix HOME setting
sudo chmod a+w .
export HOME=/home/user

# Group options
if test -n "${GROUP}"; then
    REPO_GROUP_OPTIONS="-g default,${GROUP}"
    MAKE_SETUP_TARGET="setup-${GROUP}"
else
    MAKE_SETUP_TARGET="setup"
fi

# Launch repo initialization
repo init -u "${URL}" -m "${MANIFEST}" ${REPO_GROUP_OPTIONS} --depth=1
.repo/repo/repo sync -j "${CPUs}"

# Prepare some environment
export CI=1
export CI_PROJECT=`basename ${GITHUB_REPOSITORY}`
IS_TAG="$(echo "${GITHUB_REF}" | grep "refs/tags/" || true)"

# Check for tag manifest
if test "${MANIFEST%%/*}" == "tags" -a "${CI_PROJECT}" == "workspace" -a -n "${IS_TAG}"; then
    # Deduce project from tag name; and keep manifest as is
    export CI_PROJECT="$(echo ${MANIFEST} | sed -e "s|tags/\([^/]*\)/.*|\1|")"
else
    if test -n "${IS_TAG}"; then
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
fi

# Prepare env vars
for VAR in $(echo ${ENVVARS} | sed -e "s|,| |g"); do
    eval "export $VAR"
done

# Use Makefile setup
make ${MAKE_SETUP_TARGET}
