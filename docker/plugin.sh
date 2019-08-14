#!/bin/sh
set -euo pipefail

export PATH=$PATH:/docker/

REGISTRY=${INPUT_REGISTRY:-index.docker.io}

if [ "${INPUT_USERNAME:-}" ] || [ "${INPUT_PASSWORD:-}" ]; then
    DOCKER_AUTH=`echo -n "${INPUT_USERNAME}:${INPUT_PASSWORD}" | base64 | tr -d "\n"`
    cat > /root/.docker/config.json <<DOCKERJSON
{
    "auths": {
        "${REGISTRY}": {
            "auth": "${DOCKER_AUTH}"
        }
    }
}
DOCKERJSON
fi

DOCKERFILE=${INPUT_DOCKERFILE:-Dockerfile}
CONTEXT=${INPUT_CONTEXT:-'.'}
LOG=${INPUT_LOG_LEVEL:-info}
EXTRA_OPTS=""

if [[ -n "${INPUT_TARGET:-}" ]]; then
    TARGET="--target=${INPUT_TARGET}"
fi

if [[ "${INPUT_SKIP_TLS_VERIFY:-}" == "true" ]]; then
    EXTRA_OPTS="--skip-tls-verify=true"
fi

if [ -n "${INPUT_BUILD_ARGS:-}" ]; then
    BUILD_ARGS=$(echo "${INPUT_BUILD_ARGS}" | tr ',' '\n' | while read build_arg; do echo "--build-arg=${build_arg}"; done)
fi

if [ -n "${INPUT_TAGS:-}" ]; then
    DESTINATIONS=$(echo "${INPUT_TAGS}" | tr ',' '\n' | while read tag; do echo "${REGISTRY}/${INPUT_REPO}:${tag} "; done)
elif [ -f .tags ]; then
    DESTINATIONS=$(cat .tags| tr ',' '\n' | while read tag; do echo "${REGISTRY}/${INPUT_REPO}:${tag} "; done)
elif [ -n "${INPUT_REPO:-}" ]; then
    DESTINATIONS="${INPUT_REPO}:latest"
fi

TAG_ARGS=$(echo ${DESTINATIONS} | tr ' ' '\n' | while read dst; do echo "--tag=${dst} "; done)

docker build --file=${DOCKERFILE} ${CONTEXT} \
    ${EXTRA_OPTS} \
    ${TAG_ARGS} \
    ${TARGET:-} \
    ${BUILD_ARGS:-} 

docker push ${DESTINATIONS}
