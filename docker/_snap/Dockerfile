
# FROM ubuntu:16.04

# ENV container docker
# ENV PATH /snap/bin:$PATH

# COPY snap.sh /usr/local/bin/snap

# RUN apt-get update \
# 	&& apt-get install -y snapd squashfuse fuse \
# 	&& systemctl enable snapd

# STOPSIGNAL SIGRTMIN+3

# CMD [ "/sbin/init" ]

# FROM ubuntu:xenial

# WORKDIR /root

# ENV LC_ALL=C.UTF-8 LANG=C.UTF-8 SNAPCRAFT_SETUP_CORE=1 container=docker PATH=/snap/bin:$PATH

# RUN apt update &&\
#     apt install -y fuse make snapd snap-confine squashfuse sudo snapcraft &&\
#     dpkg-divert --local --rename --add /sbin/udevadm &&\
#     ln -s /bin/true /sbin/udevadm &&\
#     systemctl enable snapd

# VOLUME ["/sys/fs/cgroup"]

# STOPSIGNAL SIGRTMIN+3

# CMD ["/sbin/init"]


FROM ubuntu:xenial as builder

# Grab dependencies
RUN apt-get update \
	&& apt-get dist-upgrade --yes \
	&& apt-get install --yes \
    	curl \
    	jq \
    	squashfs-tools

# Grab the core snap (for backwards compatibility) from the stable channel and
# unpack it in the proper place.
RUN curl -L $(curl -H 'X-Ubuntu-Series: 16' 'https://api.snapcraft.io/api/v1/snaps/details/core' | jq '.download_url' -r) --output core.snap \
	&& mkdir -p /snap/core \
	&& unsquashfs -d /snap/core/current core.snap

# Grab the core18 snap (which snapcraft uses as a base) from the stable channel
# and unpack it in the proper place.
RUN curl -L $(curl -H 'X-Ubuntu-Series: 16' 'https://api.snapcraft.io/api/v1/snaps/details/core20' | jq '.download_url' -r) --output core20.snap \
	&& mkdir -p /snap/core20 \
	&& unsquashfs -d /snap/core20/current core20.snap

# Grab the snapcraft snap from the stable channel and unpack it in the proper
# place.
RUN curl -L $(curl -H 'X-Ubuntu-Series: 16' 'https://api.snapcraft.io/api/v1/snaps/details/snapcraft?channel=stable' | jq '.download_url' -r) --output snapcraft.snap \
	&& mkdir -p /snap/snapcraft \
	&& unsquashfs -d /snap/snapcraft/current snapcraft.snap

# Create a snapcraft runner (TODO: move version detection to the core of
# snapcraft).
RUN mkdir -p /snap/bin \
	&& echo "#!/bin/sh" > /snap/bin/snapcraft \
	&& snap_version="$(awk '/^version:/{print $2}' /snap/snapcraft/current/meta/snap.yaml)" && echo "export SNAP_VERSION=\"$snap_version\"" >> /snap/bin/snapcraft \
	&& echo 'exec "$SNAP/usr/bin/python3" "$SNAP/bin/snapcraft" "$@"' >> /snap/bin/snapcraft \
	&& chmod +x /snap/bin/snapcraft

# Multi-stage build, only need the snaps from the builder. Copy them one at a
# time so they can be cached.
FROM ubuntu:xenial
COPY --from=builder /snap/core /snap/core
COPY --from=builder /snap/core20 /snap/core20
COPY --from=builder /snap/snapcraft /snap/snapcraft
COPY --from=builder /snap/bin/snapcraft /snap/bin/snapcraft

# Generate locale.
RUN apt-get update \
	&& apt-get dist-upgrade --yes \
	&& apt-get install --yes sudo locales \
	&& locale-gen en_US.UTF-8

# Set the proper environment.
ENV LANG="en_US.UTF-8"
ENV LANGUAGE="en_US:en"
ENV LC_ALL="en_US.UTF-8"
ENV PATH="/snap/bin:$PATH"
ENV SNAP="/snap/snapcraft/current"
ENV SNAP_NAME="snapcraft"
ENV SNAP_ARCH="amd64"
