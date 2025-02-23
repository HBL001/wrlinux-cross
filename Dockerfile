# ---------------------------
# Base Image and System Dependencies
# ---------------------------
FROM debian:bullseye

# Update package lists and install core dependencies
RUN apt-get update && \
    apt-get install -y \
      build-essential \
      curl \
      ca-certificates \
      file \
      cmake \
      git \
      libgpiod-dev \
      libsqlite3-dev \
      pkg-config \
      python3 \
      python3-numpy \
      sqlite3 \
      aptitude \
      locales \
      rsync \
      sudo \
      tmux \
      tree \
      vim && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# ---------------------------
# Create User and Working Directory
# ---------------------------
# Create the user 'user' to match your host environment
RUN useradd -m -s /bin/bash user

# Set the working directory
WORKDIR /home/user

# ---------------------------
# SDK Installation
# ---------------------------
# Copy the SDK installer into the container
COPY wrlinux-10.24.33.5-glibc-x86_64-beaglebone_yocto-core-image-minimal-sdk.sh /tmp/

# Make the SDK installer executable and run it
RUN chmod +x /tmp/wrlinux-10.24.33.5-glibc-x86_64-beaglebone_yocto-core-image-minimal-sdk.sh && \
    unset LD_LIBRARY_PATH && \
    /tmp/wrlinux-10.24.33.5-glibc-x86_64-beaglebone_yocto-core-image-minimal-sdk.sh -y -d /opt/wrlinux-toolchain && \
    rm /tmp/wrlinux-10.24.33.5-glibc-x86_64-beaglebone_yocto-core-image-minimal-sdk.sh

# ---------------------------
# Additional Configuration for Application
# ---------------------------
# Create directories for your application
RUN mkdir -p /opt/data/app_manager/config /opt/data/app_manager/logs && \
    chown -R user:user /opt/data/app_manager

# Enable compiler caching for improved rebuild performance
ENV USE_CCACHE=1
ENV CCACHE_DIR=/home/user/.ccache

# Set locale
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8

# ---------------------------
# Entrypoint Configuration
# ---------------------------
# Copy the entrypoint script into the container
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Switch to the 'user' account
USER user

# Default command: start an interactive bash shell
CMD ["bash"]
