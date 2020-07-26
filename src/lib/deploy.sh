#!/usr/bin/env bash

function deploy() {
    set -euo pipefail

    local _INPUTDIR="$( cd "$1"; pwd -P )"

    if [[ -z "${CAUR_SIGN_KEY}" ]]; then
        echo 'An signing key is required for deploying.'
        return 17
    elif [[ ! -e "${_INPUTDIR}/building.result" ]] ||\
            [[ `cat "${_INPUTDIR}/building.result"` != 'success' ]]; then
        echo 'Invalid package or last build did not succeed.'
        return 18
    fi

    mkdir -p "${CAUR_ADD_QUEUE}"

    pushd "${_INPUTDIR}/dest"
    chown "${CAUR_SIGN_USER}" .
    for f in !(*.sig); do
        sudo -u "${CAUR_SIGN_USER}" \
            gpg --detach-sign \
                --use-agent -u "${CAUR_SIGN_KEY}" \
                --no-armor "$f"

        cp "$f"{,.sig} "${CAUR_ADD_QUEUE}/"
    done
    popd

    return 0
}
