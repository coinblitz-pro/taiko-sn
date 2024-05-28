FROM golang:1.21-alpine as builder

RUN apk update && apk add --no-cache --update gcc musl-dev linux-headers git make build-base

WORKDIR /build

COPY --from=upstream go.mod go.sum ./

COPY --from=upstream packages/taiko-client/ packages/taiko-client/

WORKDIR /build/packages/taiko-client

RUN --mount=type=cache,target=/root/.cache/go-build,sharing=locked \
    make build


FROM alpine:latest

RUN apk add --no-cache ca-certificates libstdc++ bash

COPY --from=builder /build/packages/taiko-client/bin/taiko-client /usr/local/bin/

ADD entrypoint.sh /entrypoint.sh
ADD scripts /scripts

ENTRYPOINT ["/entrypoint.sh"]
