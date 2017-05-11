# symphony-build-server
Creates a docker image containing all the tools needed to build Project Symphony from source repositories.

# Build Container
You can build the container locally through docker with the following command.

```
  docker build -t symphony-build-server:latest .
```

# Run Container
The build container is best run in the background and left running as long as you need to build the code.
The *--privileged* option is used to allow running the docker daemon within the container. The internal
docker daemon is utilized to build docker images from some of the Project Symphony repositories.

The container is given a fixed name, **symphony-dev**. This is optional and does not have to be done. By
naming the running container, we can prevent multiple copies from running by accident.

There are two mount mounts from the local file system into the container. The first mount option (*-v*)
mounts the current directory into /build of the container. The local directory can be changed and should
be the directory where the Project Symphony repositories are checked out. The second mount point is 
optional and creates a long term cache of maven repository files. This is done to improve build speeds
on subsequent runs of the container. Without the option, each time the container is used to build a 
Java project with Maven, the maven dependencies will be retrieved again.

```
  docker run -d --privileged --name symphony-dev -v `pwd`:/build -v `pwd`/cache:/root/.m2  symphony-build-server
```

# Attach to Container
To attach to the running docker container, execute the following docker command.

```
  docker exec -it symphony-dev sh
```

This will execute the command 'sh' and ensures an interactive terminal.

# Start docker daemon
After attaching to the build container, you will (currently) need to start up the docker daemon manually. 
This can be done by executing the command.

```
  /etc/init.d/docker start
```

# Build Project Symphony repository
To build any of the checked out repositories, change to the /build directory and then pick a project under it.
Most projects can be built using maven.

```
  cd /build
  ls
  cd <project>
  mvn clean install
```
