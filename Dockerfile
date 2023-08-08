FROM golang:1.18-alpine as build
RUN apk --no-cache add git
WORKDIR /go/src/github.com/OWASP/Amass
COPY . .
RUN go install -v ./...

FROM alpine:3.18.3
RUN apk --no-cache add ca-certificates
COPY --from=build /go/bin/amass /bin/amass
ENV HOME /
RUN addgroup user \
    && adduser user -D -G user \
    && mkdir /.config \
    && mkdir /.config/amass \
    && chown -R user:user /.config
USER user
ENTRYPOINT ["/bin/amass"]
