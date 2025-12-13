FROM golang:1.20-alpine AS builder

WORKDIR /build

RUN apk add --no-cache git ca-certificates

# Permite fijar versión / commit
ARG FAAS_SWARM_REF=master

# Clonamos el repo oficial (archivado)
RUN git clone https://github.com/openfaas/faas-swarm.git . \
  && git checkout "${FAAS_SWARM_REF}"

# 🔥 Ignorar vendor inconsistente
ENV GOFLAGS="-mod=mod"
ENV GOPROXY="https://proxy.golang.org,direct"

# Compilación
RUN go build -o /out/faas-swarm ./...

# -------------------------
# Imagen final (runtime)
# -------------------------
FROM alpine:3.20

RUN apk add --no-cache ca-certificates

COPY --from=builder /out/faas-swarm /usr/bin/faas-swarm

EXPOSE 8080
ENTRYPOINT ["faas-swarm"]
