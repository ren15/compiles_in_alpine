FROM alpine:3.19 AS build

RUN apk update && \
    apk add \
        build-base \
        cmake \
        curl \
        git \
        gcc \
        g++ \
        libc-dev \
        linux-headers \
        ninja \
        pkgconfig \
        tar \
        unzip \
        zip \
        xz

WORKDIR /v/src

ARG ZSTD_VERSION=1.5.5

RUN curl -sSL "https://github.com/facebook/zstd/releases/download/v${ZSTD_VERSION}/zstd-${ZSTD_VERSION}.tar.gz" | \
    tar --strip-components=1 -zxf - \
    && make -j$(nproc) \
    && ls -lah /v/src/programs

# UPX
WORKDIR /v/upx/

ARG ARCH=amd64
ARG UPX_VERSION="4.2.1"

RUN curl -sSL "https://github.com/upx/upx/releases/download/v${UPX_VERSION}/upx-${UPX_VERSION}-${ARCH}_linux.tar.xz" | \
    tar --strip-components=1 -xJf - \
    && mv upx /usr/local/bin/upx

RUN ls -lah /v/src/programs/zstd && sha256sum /v/src/programs/zstd \
    && upx --ultra-brute /v/src/programs/zstd \
    && ls -lah /v/src/programs/zstd && sha256sum /v/src/programs/zstd

FROM centos:7 AS runtime

COPY --from=build /v/src/programs/zstd /usr/local/bin/zstd
COPY --from=build /lib/ld-musl-x86_64.so.1 /lib/ld-musl-x86_64.so.1

ENTRYPOINT ["/usr/local/bin/zstd"]
