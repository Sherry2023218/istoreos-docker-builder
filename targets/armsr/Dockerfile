FROM scratch
ADD bin/targets/armsr/generic/rootfs.tar.gz /
ENV container=docker
STOPSIGNAL SIGTERM
ENTRYPOINT ["/sbin/init"]
