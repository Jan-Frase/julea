#!/bin/sh

set -e 
set -u 

echo "================"
echo "Creating ceph container."
echo "================"

echo "Removing old container."
docker container rm systemd-centos-container || true

echo "Building new image."
docker build -t systemd-centos-image .

echo "Creating new container."
# docker run --privileged -it --name jans-ceph-container jans-ceph-image /bin/bash
docker run -d --name systemd-centos-container --tmpfs /tmp --tmpfs /run --tmpfs /run/lock -v /sys/fs/cgroup:/sys/fs/cgroup:ro systemd-centos-image

echo "Exec into container."
docker exec -it systemd-centos-container sh
