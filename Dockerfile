# syntax=docker/dockerfile:1

## Build
FROM golang:1.18 AS build

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY *.go ./
COPY ./route ./route
COPY ./templates ./templates
COPY ./utils ./utils
COPY ./collector ./collector

RUN go build -o /powerstore-metrics-exporter

## Deploy
FROM gcr.io/distroless/base-debian10

WORKDIR /

COPY --from=build /powerstore-metrics-exporter /usr/local/bin/powerstore-metrics-exporter

EXPOSE 9010

USER nonroot:nonroot

ENTRYPOINT ["/usr/local/bin/powerstore-metrics-exporter -c /usr/local/bin/config.yml"]
