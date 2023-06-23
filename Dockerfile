# Builder image used to build the Go binary
FROM golang:1.18-alpine AS build-stage
RUN mkdir /app
ADD . /app
WORKDIR /app
RUN go clean --modcache
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

# Pruduction image used to run the Go binary
FROM alpine:latest AS build-release-stage
RUN apk --no-cache add ca-certificates
RUN apk add --no-cache git make musl-dev go
COPY --from=build-stage /app/main .

# Configurations
ENV GOROOT /usr/lib/go
ENV GOPATH /go
ENV PATH /go/bin:$PATH

RUN mkdir -p ${GOROOT}/src ${GOPATH}/bin
CMD ["./main"]