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


RUN git clone --depth=1 https://github.com/duckdb/duckdb.git

RUN cd duckdb \
    && GENERATOR="-GNinja" make

RUN /v/src/duckdb/build/release/duckdb --version

FROM alpine:3.19 AS runtime

COPY --from=build /v/src/duckdb/build/release/duckdb /usr/local/bin/duckdb

ENTRYPOINT ["/usr/local/bin/duckdb"]
    
