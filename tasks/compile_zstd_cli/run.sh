#!/bin/bash

set -ueo pipefail

docker build \
    -t builder \
    -f tasks/compile_zstd_cli/Dockerfile.builder \
    .