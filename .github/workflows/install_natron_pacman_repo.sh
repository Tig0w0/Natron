#!/bin/bash

NATRON_DIR=
NATRON_REPO_DIR=
if [[ -z $1 || -z $2 ]]; then
  echo "Usage: $(basename $0) <natron_directory> <natron_repo_directory>"
  exit 1
else
  NATRON_DIR=$(realpath $1)
  NATRON_REPO_DIR=$(realpath $2)
fi

source ${NATRON_DIR}/tools/MINGW-packages/natron_repo_common.sh

if [[ ! -d ${NATRON_REPO_DIR} ]]; then
    mkdir ${NATRON_REPO_DIR}
fi

cd ${NATRON_REPO_DIR}

WINDOWS_PACMAN_REPO_VERSION=`cat ${NATRON_DIR}/tools/MINGW-packages/windows_pacman_repo_version.txt`
ZIP_FILENAME="natron_package_repo-${WINDOWS_PACMAN_REPO_VERSION}.zip"
# Use the pinned, published Natron dependency snapshot.
# Fail immediately if unavailable rather than silently rebuilding outdated
# dependencies with incompatible current MSYS2/autoconf versions.
if ! wget --tries=3 --timeout=40 "https://github.com/NatronGitHub/Natron/releases/download/windows-mingw-package-repo/${ZIP_FILENAME}"; then
    echo "ERROR: Missing pinned Natron pacman archive: ${ZIP_FILENAME}" >&2
    exit 1
fi
unzip -o "${ZIP_FILENAME}"

UNIX_NATRON_REPO_DIR=`cygpath -u ${NATRON_REPO_DIR}`
natron_repo_init ${UNIX_NATRON_REPO_DIR}
