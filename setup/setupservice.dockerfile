FROM alpine:latest
RUN apk --no-cache add postgresql15-client
ENTRYPOINT [ "/tmp/setup.sh" ]