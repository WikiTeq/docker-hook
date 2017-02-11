# docker-hook

> Automatic Docker Deployment via [Webhooks](https://docs.docker.com/docker-hub/repos/#webhooks)

`docker-hook` listens to incoming HTTP requests and triggers your specified command.

## Features

* No dependencies
* Super lightweight
* Dead **simple setup process**
* Authentication support

## Setup

### 1. Prepare Your Server

#### Start `docker-hook`

Arguments for docker-hook can be passed to docker run, e.g.:

    docker run --rm nilbus/docker-hook --help

    docker run -d --name docker-hook -p 8555:8555 nilbus/docker-hook -t <auth-token> -c <command>

If your command needs control over the docker daemon it's running in, give it control
from within the container by mounting the Docker socket:

    docker run \
      -d \
      --name docker-hook \
      -p 8555:8555 \
      -v /var/run/docker.sock:/var/run/docker.sock \
      nilbus/docker-hook -t <auth-token> -c <command>

##### Auth-Token

Please choose a secure `auth-token` string or generate one with `$ uuidgen`. Keep it safe or otherwise other people might be able to trigger the specified command.

##### Command

The `command` can be any bash command of your choice. This command will be triggered each time someone makes an HTTP request with a valid token.

### 2. Configuration On Docker Hub

Add a webhook like on the following image. `example.com` can be the domain of your server or its ip address. `docker-hook` listens to port `8555`. Please replace `my-super-safe-token` with your `auth-token`.

![](http://i.imgur.com/B6QyfmC.png)

## Example

This example will stop the current running `yourname/app` container, pull the newest version and start a new container.

    docker run \
      -d \
      --name docker-hook \
      -p 8555:8555 \
      -v /var/run/docker.sock:/var/run/docker.sock \
      -v ./deploy.sh:/deploy.sh \
      nilbus/docker-hook -t my-super-safe-token -c sh /deploy.sh

#### `deploy.sh`

```sh
#!/bin/bash

IMAGE="yourname/app"
docker ps | grep $IMAGE | awk '{print $1}' | xargs docker stop
docker pull $IMAGE
docker run -d $IMAGE
```

You can now test it by pushing something to `yourname/app` or by running the following command where `yourdomain.com` is either a domain pointing to your server or just its ip address.

```sh
$ curl -X POST yourdomain.com:8555/my-super-safe-token
```

## How it works

`docker-hook` uses `BaseHTTPRequestHandler` to listen for incoming HTTP requests from Docker Hub and then executes the provided [command](#command) if the [authentication](#auth-token) was successful.

## Caveat

This tool was built as a proof-of-concept and might not be completly secure. If you have any improvement suggestions please open up an issue.

## License

[MIT License](http://opensource.org/licenses/MIT)
