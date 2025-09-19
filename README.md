# svcbox-rootless

![icon](icon.svg)

[![GitHub main workflow](https://img.shields.io/github/actions/workflow/status/dmotte/svcbox-rootless/main.yml?branch=main&logo=github&label=main&style=flat-square)](https://github.com/dmotte/svcbox-rootless/actions)
[![Docker Pulls](https://img.shields.io/docker/pulls/dmotte/svcbox-rootless?logo=docker&style=flat-square)](https://hub.docker.com/r/dmotte/svcbox-rootless)

:rocket: Docker image with **supervisord** and **sshd** (rootless version). This image is almost equivalent to [dmotte/svcbox](https://github.com/dmotte/svcbox) but it runs as a **non-root user**.

> :package: This image is also on **Docker Hub** as [`dmotte/svcbox-rootless`](https://hub.docker.com/r/dmotte/svcbox-rootless) and runs on **several architectures** (e.g. amd64, arm64, ...). To see the full list of supported platforms, please refer to the [`.github/workflows/main.yml`](.github/workflows/main.yml) file. If you need an architecture which is currently unsupported, feel free to open an issue.

## Usage

In general, the use of this image is very similar to [dmotte/svcbox](https://github.com/dmotte/svcbox), but:

- If you want the container to generate missing **SSH host keys**, the related **volume(s) must be writable** by the `mainuser` user of the container; otherwise, the generated keys won't be written to the volume
- See the usage example of [dmotte/docker-portmap-server-rootless](https://github.com/dmotte/docker-portmap-server-rootless) for other useful tips that may be applicable to this image too, since the SSH keys management is almost the same

> **Note**: even if the container is running as an unprivileged user, you can still use `docker exec -ituroot mycontainer bash` to run commands as root inside it.

## More info

For more info see the [dmotte/svcbox](https://github.com/dmotte/svcbox) project, which is very similar to this one.
