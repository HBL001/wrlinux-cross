# To cross compile for the AM3358 on your x68 development PC


docker run -v /home/user:/home/user cu1bo/wrlinux-cross:latest bash



The -v /home/user:/home/user option tells Docker to bind mount the host directory /home/user into the container at /home/user. This means any files in that directory on your host will be visible in the container and vice versa.

You can use this to share code, configuration, or other data between your host and the container.

