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
        zip

WORKDIR /v/src

RUN curl -sSL "https://github.com/facebook/zstd/releases/download/v1.5.5/zstd-1.5.5.tar.gz" | \
    tar --strip-components=1 -zxf - \
    && make -j$(nproc) \
    && ls -lah /v/src/programs

FROM alpine:3.19 AS runtime

COPY --from=build /v/src/programs/zstd /usr/local/bin/zstd

ENTRYPOINT ["/usr/local/bin/zstd"]
