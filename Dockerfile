FROM golang:1.20-alpine AS builder

WORKDIR /build

RUN apk add --no-cache git

RUN git clone https://github.com/openfaas/faas-swarm.git .

RUN go build -o faas-swarm

FROM alpine:3.20

WORKDIR /root/

COPY --from=builder /build/faas-swarm /usr/bin/faas-swarm

EXPOSE 8080

ENTRYPOINT ["faas-swarm"]
