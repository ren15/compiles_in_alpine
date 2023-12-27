#!/bin/bash

set -ueo pipefail

DOCKER_BUILDKIT=1 BUILDKIT_PROGRESS=plain \
docker build \
    -t builder \
    -f tasks/compile_zstd_cli/Dockerfile.builder \
    .

docker run \
    --rm \
    --entrypoint=/bin/bash \
    -e LD_LIBRARY_PATH=/lib \
    builder \
        -c "ls -lah /lib/ /usr/local/bin && env && ldd /usr/local/bin/zstd"

docker run --rm  builder --version
