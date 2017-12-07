FROM alpine:3.6

MAINTAINER Amir Mofasser (@amimof)

RUN apk add --no-cache --update openssh bash \
&&  mkdir -p /var/run/sshd \
&&  chmod +x /server

COPY sshd_config /etc/ssh/sshd_config
COPY server /

EXPOSE 22

CMD ["/server"]
