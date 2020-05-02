#!/bin/bash
set -ex

# Get inputs
URL="$1"
shift
MANIFEST="$1"
shift
BRANCH="$1"
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

# Prepare some environment
export CI=1
export CI_PROJECT=`basename ${GITHUB_REPOSITORY}`
IS_TAG="$(echo "${GITHUB_REF}" | grep "refs/tags/" || true)"
if test -n "${IS_TAG}"; then
    export CI_TAG=`basename ${GITHUB_REF}`
fi
IS_BRANCH="$(echo "${GITHUB_REF}" | grep "refs/heads/" || true)"
if test -n "${IS_BRANCH}"; then
    export CI_BRANCH=`basename ${GITHUB_REF}`
fi

# Branch option
if test -n "${BRANCH}"; then
    # User specified
    REPO_BRANCH_OPTIONS="-b ${BRANCH}"
elif test "${CI_PROJECT}" == "workspace" -a -n "${IS_BRANCH}"; then
    # Branch mode on the workspace itself
    REPO_BRANCH_OPTIONS="-b ${CI_BRANCH}"
fi

# Group options
if test -n "${GROUP}"; then
    REPO_GROUP_OPTIONS="-g default,${GROUP}"
    MAKE_SETUP_TARGET="setup-${GROUP}"
else
    MAKE_SETUP_TARGET="setup"
fi

# Special manifest handling
if test "${MANIFEST}" == "fromRef"; then
    # Resolve manifest from ref
    MANIFEST="$(echo "${GITHUB_REF}" | sed -e "s|refs/.*/\(.*\)-\(.*\)|tags/\1/\2.xml|")"
fi

# Launch repo initialization
repo init -u "${URL}" -m "${MANIFEST}" ${REPO_BRANCH_OPTIONS} ${REPO_GROUP_OPTIONS} --depth=1
.repo/repo/repo sync -j "${CPUs}"

# Check for tag manifest
if test "${MANIFEST%%/*}" == "tags" -a "${CI_PROJECT}" == "workspace"; then
    # Deduce project from tag/branch name; and keep manifest as is
    export CI_PROJECT="$(echo ${MANIFEST} | sed -e "s|tags/\([^/]*\)/.*|\1|")"
else
    if test -n "${IS_TAG}"; then
        # Prepare setup for current tag
        export MANIFEST_TAGS="${CI_PROJECT}"/"${CI_TAG}"
    else
        # Prepare setup for current branch (if not master)
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
