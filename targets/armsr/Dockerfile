FROM scratch
ADD rootfs.tar.gz /
ENV container=docker
STOPSIGNAL SIGTERM
ENTRYPOINT ["/sbin/init"]
