#!/bin/sh

set -e 
set -u 

echo "================"
echo "Creating storage file."
echo "================"

dd if=/dev/zero of=ceph-osd.disk bs=1M count=8192
LOOP=$(losetup -f)
sudo losetup $LOOP ceph-osd.disk

echo "==============="
echo "Install CephADM: https://docs.ceph.com/en/quincy/cephadm/"
echo "==============="

# Set the desired release. List of releases: https://docs.ceph.com/en/latest/releases/#active-releases
CEPH_RELEASE=19.2.3
# Download cephadm
curl --silent --remote-name --location https://download.ceph.com/rpm-${CEPH_RELEASE}/el9/noarch/cephadm
# Make cephadm executable
chmod +x cephadm

# Install cephadm.
# If we ever change the release "tentacle" needs to be changed too!
# ./cephadm add-repo --release squid 
# ./cephadm install

# Sanity check that everything was installed correctly. Should return: /usr/bin/cephadm
# echo "Running 'which cephadm'. Should return: /usr/bin/cephadm"
# which cephadm

echo "IP:"
IP=192.168.178.39
echo $IP


echo "==============="
echo "Install cephadm dependencies."
echo "==============="

sudo dnf install docker -y

echo "================"
echo "Starting cephadm bootstrap."
echo "================"

./cephadm bootstrap --mon-ip $IP --single-host-defaults --allow-overwrite --allowerasing

