# Containers

For easier setup or testing JULEA, you can use the development container, which contains JULEA's required dependencies.

## Development Container

Setting up and using the container looks like the following:

```console
git clone https://github.com/parcio/julea.git &&

docker pull ghcr.io/parcio/julea/ubuntu:24.04-base &&
docker run -v $PWD/julea:/julea -it ghcr.io/parcio/julea/ubuntu:24.04-base
```

Continue with the following commands inside the container:

```console
cd /julea &&
. scripts/environment.sh &&

meson setup --prefix="/julea/install" -Db_sanitize=address,undefined bld &&
ninja -C bld &&

julea-config --user \
  --object-servers="$(hostname)" --kv-servers="$(hostname)" --db-servers="$(hostname)" \
  --object-backend=posix --object-path="/tmp/julea-$(id -u)/posix" \
  --kv-backend=lmdb --kv-path="/tmp/julea-$(id -u)/lmdb" \
  --db-backend=sqlite --db-path="/tmp/julea-$(id -u)/sqlite" &&

./scripts/setup.sh start &&
./scripts/test.sh &&
./scripts/setup.sh stop
```

### Building Container

The Dockerfiles can be found in the `containers` directory.
To build a container, use the following commands:

```console
cd julea/containers &&
docker build -f ubuntu-24.04 -t parcio/julea/ubuntu:24.04-base .
```
