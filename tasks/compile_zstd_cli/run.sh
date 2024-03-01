#!/bin/bash

set -ueo pipefail

pushd $(dirname "$0")
. ../../common/env.sh

DOCKER_BUILDKIT=1 BUILDKIT_PROGRESS=plain \
docker build \
    -t builder \
    --build-arg "BUILDER=${ALPINE_BUILDER}" \
    -f tasks/compile_zstd_cli/Dockerfile.builder \
    .

docker run \
    --rm \
    --entrypoint=/bin/bash \
    -e LD_LIBRARY_PATH=/lib \
    builder \
        -c "ls -lah /lib/ /usr/local/bin && env && /usr/local/bin/zstd"

docker run --rm  builder --version
