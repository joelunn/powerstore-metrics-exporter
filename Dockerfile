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

RUN go build -o /PowerStoreExporter

## Deploy
FROM gcr.io/distroless/base-debian10

RUN mkdir -p /etc/powerstore-exporter
RUN mkdir -p /etc/powerstore-exporter/config

WORKDIR /

COPY --from=build /PowerStoreExporter /etc/powerstore-exporter/PowerStoreExporter

EXPOSE 9010

USER nonroot:nonroot

ENTRYPOINT ["/etc/powerstore-exporter/PowerStoreExporter", "-c", "/etc/powerstore-exporter/config.yml"]
