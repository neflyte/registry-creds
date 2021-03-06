FROM golang:1.12-buster AS build-stage
# FIXME: Fix the line below before merging
WORKDIR /go/src/github.com/neflyte/registry-creds
COPY . .
RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -a -o registry-creds -ldflags '-s -w' main.go

FROM alpine:latest AS production-stage
MAINTAINER Steve Sloka <steve@stevesloka.com>
RUN apk --no-cache update && apk --no-cache upgrade && apk --no-cache add --update ca-certificates && rm -rf /var/cache/apk/*
WORKDIR /
# FIXME: Fix the line below before merging
COPY --from=build-stage /go/src/github.com/neflyte/registry-creds/registry-creds registry-creds
ENTRYPOINT ["/registry-creds"]
