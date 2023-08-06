#!/usr/bin/env bash

get_auth() {
    echo $(secret-tool lookup backup-name "$1")
}

if [[ "$#" -lt 4 ]]; then
    echo "Usage: `basename $0` command remote-root backup-name local-dir"
    exit -1
fi

COMMAND="${1}" REMOTE_ROOT="${2}"
BACKUP_NAME="${3}"
LOCAL_DIR="${4}"
REMOTE_DEST="${REMOTE_ROOT}/${BACKUP_NAME}"

if [[ ! -d "${LOCAL_DIR}" ]]; then
    echo "Dir ${LOCAL_DIR} not found"
    exit -1
fi

export PASSPHRASE=$(secret-tool lookup backup-name "${BACKUP_NAME}")

if [ "${COMMAND}" == "v" ]; then
    duplicity verify --compare-data -v3 --progress "${REMOTE_DEST}" "${LOCAL_DIR}"
elif [ "${COMMAND}" == "vl" ]; then
    duplicity verify -v3 --progress "${REMOTE_DEST}" "${LOCAL_DIR}"
elif [ "${COMMAND}" == "b" ]; then
    duplicity --progress -v3 "${LOCAL_DIR}" "${REMOTE_DEST}"
elif [ "${COMMAND}" == "r" ]; then
    duplicity restore -vi "${REMOTE_DEST}" "${LOCAL_DIR}"
else
    echo "Invalid command ${COMMAND}"
fi
