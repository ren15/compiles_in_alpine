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


docker run --rm  builder --version

docker run --rm  builder -s "SELECT 1"

# docker run --rm  builder -s "INSTALL httpfs;LOAD httpfs;SELECT * FROM 'https://shell.duckdb.org/data/tpch/0_01/parquet/lineitem.parquet';"
