# sftp

A fast and secure [SFTP](https://en.wikipedia.org/wiki/SSH_File_Transfer_Protocol) server that runs in a container on [`Alpine Linux`](https://alpinelinux.org/), optimised for [`Kubernetes`](https://kubernetes.io/).

## Usage
Configuration parameters are passed in to the container through environment variables. All variables are optional so that you can run a container with minimum configuration. The simples way of running using `Docker` is by using the following command.
```
$ docker run -p 22:22 -e SSH_PASSWORD=notsecure amimof/sftp:latest
```
Note that even though the username defaults to `sftpuser`, we still need to specify a password. All though it's not required, but the container wont do you much good without one.

### Environment Variables
| Variable | Default Value | Description |
| :------ | :------ | :------ |
| `SSH_USERNAME` | `sftpuser` | Username of the sftp user |
| `SSH_PASSWORD` | - | A password for the user. Setting this environment variable will allow `PasswordAuthentication`. |
| `SSH_USERID` | `1337` | The Linux user id of the sftp user |
| `SSH_DATADIR_NAME` | `data` | Name of the directory created under `/home/<username>/`. Defaults to `/home/<username>/data/` |
| `SSH_GENERATE_HOSTKEYS` | `true` | Skips generation if host keys of set to false. Useful when providing your own set of host keys. |
| `LOG_LEVEL` | `INFO` | Use this environment variable to set the `LogLevel` directive in `sshd_config` |
| `DEBUG` | `false` | Set to `true` to start `sshd` in debug mode. `sshd -d` |

## Examples

### Username & password authentication
```
$ docker run \
    -p 22:22 \
    -e SSH_USERNAME=sftpuser \
    -e SSH_PASSWORD=notsecure \
    amimof/sftp:latest
```

### SSH key authentication
```
$ docker run \
    -p 22:22 \
    -e SSH_USERNAME=sftpuser \
    -v ~/.ssh/id_rsa.pub:/home/sftpuser/.ssh/id_rsa.pub \
    amimof/sftp:latest
```

### Specify SSH host keys
SSH host keys will be automatically generated and change between container restarts unless specified otherwise with the `SSH_GENERATE_HOSTKEYS` environment variable. To avoid `man-in-the-middle attack` warnings you can mount your own host keys into the container.
```
$ docker run \
    -p 22:22 \
    -e SSH_USERNAME=sftpuser \
    -e SSH_PASSWORD=notsecure \
    -e SSH_GENERATE_HOSTKEYS=false \
    -v ~/ssh_host_ed25519_key:/etc/ssh/host_keys/ssh_host_ed25519_key \
    -v ~/ssh_host_rsa_key:/etc/ssh/host_keys/ssh_host_rsa_key \
    amimof/sftp:latest
```

**NOTE!** The host keys are placed in the non-default location of `/etc/ssh/host_keys/` so that you can mount your host keys using a `Kubernetes Secret`. If the secret is mounted on the host key's *default* location, `/etc/ssh/`, all other files in that directory would be overwritten, including `sshd_config` which would prevent the ssh server from starting correctly.
