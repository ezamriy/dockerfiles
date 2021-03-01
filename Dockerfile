FROM scratch
ADD cloudlinux-8-docker.tar.xz /

# see https://github.com/opencontainers/image-spec/blob/master/annotations.md for details
LABEL org.opencontainers.image.title="CloudLinux OS 8 Base Image"
LABEL org.opencontainers.image.vendor="CloudLinux OS"
# TODO: should we list all included RPM package licenses here?
#       Right now it is just our Dockerfile/build scripts license.
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.created="2021-03-01 21:58:18+00:00"
LABEL org.opencontainers.image.authors="Eugene Zamriy <ezamriy@cloudlinux.com>"
LABEL org.opencontainers.image.source="https://github.com/ezamriy/dockerfiles"
LABEL org.opencontainers.image.url="https://github.com/ezamriy/dockerfiles"

CMD ["/bin/bash"]
