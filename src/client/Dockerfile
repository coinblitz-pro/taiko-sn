FROM golang:1.21-alpine as builder

RUN apk update && apk add --no-cache --update gcc musl-dev linux-headers git make build-base

WORKDIR /taiko-client
COPY --from=upstream . .
RUN make build


FROM alpine:latest

RUN apk add --no-cache ca-certificates libstdc++ bash

COPY --from=builder /taiko-client/bin/taiko-client /usr/local/bin/

ADD entrypoint.sh /entrypoint.sh
ADD scripts /scripts

ENTRYPOINT ["/entrypoint.sh"]
