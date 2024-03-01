ARG BUILDER
FROM ${BUILDER} AS build

RUN apk update && \
    apk add \
        build-base \
        cmake \
        make \
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
        xz \
        gcompat

WORKDIR /v/src


RUN git clone -b v0.9.2 --depth=1 https://github.com/duckdb/duckdb.git

RUN cd duckdb \
    && GEN=ninja make

RUN /v/src/duckdb/build/release/duckdb --version
RUN ldd /v/src/duckdb/build/release/duckdb

FROM alpine:3.19 AS runtime

RUN apk add --no-cache gcompat

COPY --from=build /v/src/duckdb/build/release/duckdb /usr/local/bin/duckdb
COPY --from=build /usr/lib/libstdc++.so.6 /usr/lib/libstdc++.so.6
COPY --from=build /usr/lib/libgcc_s.so.1 /usr/lib/libgcc_s.so.1
# COPY --from=build /lib64/ld-linux-x86-64.so.2 /lib/ld-linux-x86-64.so.2

ENTRYPOINT ["/usr/local/bin/duckdb"]
    
