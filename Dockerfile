FROM alpine:3.4

RUN apk update \
 && apk add \
        build-base \
 && true

RUN apk add \
        autoconf \
        automake \
        git \
        libc6-compat \
        libtool \
 && true

COPY \
    libyaml-parser.c \
    libyaml-emitter.c \
    Makefile \
        /libyaml-parser-emitter/

RUN \
(   cd /libyaml-parser-emitter/  \
 && export LD_LIBRARY_PATH=$PWD/libyaml/src/.libs \
 && make clean build \
)

ENV LD_LIBRARY_PATH=/libyaml-parser-emitter/libyaml/src/.libs

WORKDIR /docker
