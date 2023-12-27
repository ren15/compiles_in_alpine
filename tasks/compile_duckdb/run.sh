#!/bin/bash

set -ueo pipefail

DOCKERFILE_PATH=$(readlink -f $(dirname "$0")/Dockerfile.builder)
pushd $(dirname "$0")

DOCKER_BUILDKIT=1 BUILDKIT_PROGRESS=plain \
docker build \
    -t builder \
    -f $DOCKERFILE_PATH \
    .


docker run --rm  builder --version
