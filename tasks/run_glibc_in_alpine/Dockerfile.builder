# syntax = docker/dockerfile:1.4.0
ARG BUILDER
FROM centos:7 AS builder

RUN yum install gcc -y

COPY compile.sh /v/src/

RUN bash /v/src/compile.sh

FROM ${BUILDER} AS runner

COPY --from=builder /tmp/hello /usr/local/bin/hello

RUN apk add --no-cache gcompat

RUN apk info -L gcompat


RUN /usr/local/bin/hello

ENTRYPOINT ["/usr/local/bin/hello"]



