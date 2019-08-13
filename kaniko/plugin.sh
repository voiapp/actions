#!/busybox/sh

set -euo pipefail

export PATH=$PATH:/kaniko/

REGISTRY=${INPUT_REGISTRY:-index.docker.io}

if [ "${INPUT_USERNAME:-}" ] || [ "${INPUT_PASSWORD:-}" ]; then
    DOCKER_AUTH=`echo -n "${INPUT_USERNAME}:${INPUT_PASSWORD}" | base64 | tr -d "\n"`

    cat > /kaniko/.docker/config.json <<DOCKERJSON
{
    "auths": {
        "${REGISTRY}": {
            "auth": "${DOCKER_AUTH}"
        }
    }
}
DOCKERJSON
fi

if [ "${INPUT_JSON_KEY:-}" ];then
    echo "${INPUT_JSON_KEY}" > /kaniko/gcr.json
    export GOOGLE_APPLICATION_CREDENTIALS=/kaniko/gcr.json
fi

DOCKERFILE=${INPUT_DOCKERFILE:-Dockerfile}
CONTEXT=${INPUT_CONTEXT:-$PWD}
LOG=${INPUT_LOG:-info}
EXTRA_OPTS=""

if [[ -n "${INPUT_TARGET:-}" ]]; then
    TARGET="--target=${INPUT_TARGET}"
fi

if [[ "${INPUT_SKIP_TLS_VERIFY:-}" == "true" ]]; then
    EXTRA_OPTS="--skip-tls-verify=true"
fi

if [[ "${INPUT_CACHE:-}" == "true" ]]; then
    CACHE="--cache=true"
fi

if [ -n "${INPUT_BUILD_ARGS:-}" ]; then
    BUILD_ARGS=$(echo "${INPUT_BUILD_ARGS}" | tr ',' '\n' | while read build_arg; do echo "--build-arg=${build_arg}"; done)
fi
if [ -n "${INPUT_TAGS:-}" ]; then
    DESTINATIONS=$(echo "${INPUT_TAGS}" | tr ',' '\n' | while read tag; do echo "--destination=${REGISTRY}/${INPUT_REPO}:${tag} "; done)
elif [ -f .tags ]; then
    DESTINATIONS=$(cat .tags| tr ',' '\n' | while read tag; do echo "--destination=${REGISTRY}/${INPUT_REPO}:${tag} "; done)
elif [ -n "${INPUT_REPO:-}" ]; then
    DESTINATIONS="--destination=${INPUT_REPO}:latest"
else
    DESTINATIONS="--no-push"
    # Cache is not valid with --no-push
    CACHE=""
fi
/kaniko/executor -v ${LOG} \
    --context=${CONTEXT} \
    --dockerfile=${DOCKERFILE} \
    ${EXTRA_OPTS} \
    ${DESTINATIONS} \
    ${CACHE:-} \
    ${TARGET:-} \
    ${BUILD_ARGS:-}
