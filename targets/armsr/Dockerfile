FROM scratch
ADD bin/*.tar.gz /
ENV container docker
STOPSIGNAL SIGTERM
ENTRYPOINT ["/sbin/init"]
