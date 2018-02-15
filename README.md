# symphony-build-server
Creates a docker image containing all the tools needed to build 
[Project Symphony](https://github.com/dellemc-symphony) from source repositories.

# Prerequisites
To build the symphony-build-server docker image, you must have 
[docker](https://www.docker.com/community-edition#/download) installed in your build environment.

# Build
## Build Container
You can build the container locally through docker with the following command.

```
  docker build -t connect-home-test-image:latest .
```

## Run Container
The build container is best run in the background and left running as long as you need to build the code.
The *--privileged* option is used to allow running the docker daemon within the container. The internal
docker daemon is utilized to build docker images.

The container is given a fixed name, **connect-home-test-image**. This is optional and does not have to be done. By
naming the running container, we can prevent multiple copies from running by accident.

## Attach to Container
To attach to the running docker container, execute the following docker command.

```
  docker exec -it connect-home-test-image sh
```

This will execute the command 'sh' and ensures an interactive terminal.
