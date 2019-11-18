# simple multi-stage builder for go app

#builder
FROM golang:alpine as builder 

RUN apk update && apk add --no-cache git
RUN adduser -D -g '' gouser

WORKDIR $GOPATH/src/go-web/main
COPY ./main.go .

RUN go get -d -v
RUN go build -o /go/bin/go-web

#final
FROM alpine

WORKDIR /webserver

COPY --from=builder /go/bin/go-web /go/bin/go-web
COPY --from=builder /etc/passwd /etc/passwd

EXPOSE 8080

USER gouser

ENTRYPOINT /go/bin/go-web