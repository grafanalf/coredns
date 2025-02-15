FROM --platform=$BUILDPLATFORM debian:stable-slim
SHELL [ "/bin/sh", "-ec" ]

RUN export DEBCONF_NONINTERACTIVE_SEEN=true \
           DEBIAN_FRONTEND=noninteractive \
           DEBIAN_PRIORITY=critical \
           TERM=linux ; \
    apt-get -qq update ; \
    apt-get -yyqq upgrade ; \
    apt-get -yyqq install ca-certificates ; \
    apt-get clean

FROM --platform=$TARGETPLATFORM alpine:3.17.1

COPY --from=0 /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ADD coredns /coredns

EXPOSE 53 53/udp
ENTRYPOINT ["/coredns"]
