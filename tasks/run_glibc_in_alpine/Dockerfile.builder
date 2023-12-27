# syntax = docker/dockerfile:1.4.0
FROM centos:7 AS builder

RUN yum install gcc -y

COPY compile.sh /v/src/

RUN bash /v/src/compile.sh

FROM alpine:3.19 AS runner

COPY --from=builder /tmp/hello /usr/local/bin/hello

RUN apk add --no-cache gcompat

RUN apk info -L gcompat


RUN /usr/local/bin/hello

ENTRYPOINT ["/usr/local/bin/hello"]



