#!/bin/bash

set -ueo pipefail

DOCKERFILE_PATH=$(readlink -f $(dirname "$0")/Dockerfile.builder)

pushd $(dirname "$0")
. ../../common/env.sh

DOCKER_BUILDKIT=1 BUILDKIT_PROGRESS=plain \
docker build \
    -t builder \
    --build-arg "BUILDER=${ALPINE_BUILDER}" \
    -f $DOCKERFILE_PATH \
    .


docker run \
    --rm \
    builder

docker run \
    --rm \
    --entrypoint /bin/sh \
    builder \
        -c 'ldd /usr/local/bin/hello'
