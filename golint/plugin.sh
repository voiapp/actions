#!/bin/sh

set -e

export PATH=$PATH:/usr/bin/

if [ -n "${INPUT_CONFIG}" ]; then
    CONFIG="--config=${INPUT_CONFIG}"
fi 

FILES=$(echo ${INPUT_FILES} | tr ',' ' ')

golangci-lint ${CONFIG:-} run ${FILES:-}
