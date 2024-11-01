# syntax=docker/dockerfile:1

## Build
FROM golang:1.18 AS build

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

RUN go build -o /go-spooky

## Deploy
FROM gcr.io/distroless/base-debian10

WORKDIR /

COPY --from=build /powerstore-metrics-exporter ~/powerstore-metrics-exporter

EXPOSE 9010

USER nonroot:nonroot

ENTRYPOINT ["/PowerStoreExporter -c config.yml"]
