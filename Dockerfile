#
# TODO: Create a docker-compose file for developers
#       Create a named docker volume
#       Mount the volume under /root/.m2/
#       This allows downloaded maven packages to be cached between runs
#
# NOTE: The build team would use the image without the compose file
#       to ensure the maven packages are *not* cached between runs
#
# To build the container, run the following docker command
#
#   docker build -t symphony-build-server:latest .
#
# To use this container to build Symphony, start the container with the 
# following CLI options
#
#   docker run -d --privileged --name symphony-dev -v `pwd`:/build -v `pwd`/cache:/root/.m2  symphony-build-server
#
# This will run the container in the background. This is done
# so that the init process will run which can be used to spawn
# a docker daemon inside of the container. This is needed for
# packaging a symphony build.
#
# To attach to the container, use the CLI
#
#   docker exec -it symphony-dev sh
#
# Now you can build the symphony code.
#
#   cd /build
#   ls
#   cd <project>
#   mvn clean install
#

#
# Start with a recent version of Alpine with openjdk installed
#
FROM openjdk:8-jdk-alpine

#
# Add additional build tools that are needed
RUN apk update && \
    apk add maven \
            go go-tools \
            rpm \
            git git-bash-completion \
            zip unzip \
            docker docker-bash-completion openrc \
            bash bash-completion \
            make py-pip \
            && \

    #
    # LEGAL: Process to run Alpine with openrc in a container pulled from
    # https://github.com/neeravkumar/dockerfiles/blob/master/alpine-openrc/Dockerfile
    #
    # Tell openrc its running inside a container, till now that has meant LXC
    sed -i 's/#rc_sys=""/rc_sys="lxc"/g' /etc/rc.conf && \
    
    # Tell openrc loopback and net are already there, since docker handles the networking
    echo 'rc_provide="loopback net"' >> /etc/rc.conf && \
    
    # no need for loggers
    sed -i 's/^#\(rc_logger="YES"\)$/\1/' /etc/rc.conf && \
    
    # can't get ttys unless you run the container in privileged mode
    sed -i '/tty/d' /etc/inittab && \

    # can't set hostname since docker sets it
    sed -i 's/hostname $opts/# hostname $opts/g' /etc/init.d/hostname && \

    # can't mount tmpfs since not privileged
    sed -i 's/mount -t tmpfs/# mount -t tmpfs/g' /lib/rc/sh/init.sh && \
    
    # can't do cgroups
    sed -i 's/cgroup_add_service /# cgroup_add_service /g' /lib/rc/sh/openrc-run.sh && \
    
    # clean apk cache
    rm -rf /var/cache/apk/* && \

    # add docker to the startup sequence so it is running when the container starts
    rc-update add docker 

# Run the init daemon process (PID 1) so that we can start the docker daemon later
ENTRYPOINT ["/sbin/init"]
