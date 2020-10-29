# #########################################
#  BASE IMAGE
FROM golang:1.15-alpine as base
RUN apk update && apk add --no-cache git

# #########################################
#  DEV IMAGE
FROM base as dev
# ADD in air file monitor
RUN go get -u github.com/cosmtrek/air
COPY ./docker/app/air.conf /tmp/air.conf
WORKDIR /go/src/github.com/absurdsoft/slackserv
# SETUP LIVE RELOAD
CMD air -c /tmp/air.conf


# #########################################
#  PRODUCTION BINARY IMAGE BUILD
FROM base as builder
WORKDIR /go/src/github.com/absurdsoft/slackserv 
ADD . /go/src/github.com/absurdsoft/slackserv 
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .
RUN chmod +x main

FROM iron/base as binary
# COPY IN COMPILED BINARY
WORKDIR /app
COPY --from=builder /go/src/github.com/absurdsoft/slackserv/main /app/slackserv 
# ADD config.yml /app/

CMD  /app/slackserv

