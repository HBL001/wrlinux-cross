# ---------------------------
# Base Image and System Dependencies
# ---------------------------
FROM debian:bullseye

# Update package lists and install core dependencies (including 'file' which is needed)
RUN apt-get update && \
    apt-get install -y \
      build-essential \
      curl \
      ca-certificates \
      openssh-server \
      file

# Install additional build tools and required libraries for Wind River LTS 24:
RUN apt-get install -y \
    cmake \
    git \
    libgpiod-dev \
    libsqlite3-dev \
    pkg-config \
    python3 \
    python3-numpy \
    sqlite3

# Install other useful development tools.
RUN apt-get install -y \
    aptitude \
    locales \
    rsync \
    sudo \
    tmux \
    tree \
    vim

# Clean up apt caches to reduce image size.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Disable colored Git output for non-interactive environments.
RUN git config --global color.ui false

# ---------------------------
# Create User and Working Directory
# ---------------------------
# Create the user 'user' to match your host environment.
RUN useradd -m -s /bin/bash user

# Create a working directory for initial operations.
RUN mkdir -p /home/user/tmp-working
WORKDIR /home/user/tmp-working

# ---------------------------
# SDK Installation
# ---------------------------
# Copy the SDK installer into the container.
COPY wrlinux-10.24.33.5-glibc-x86_64-beaglebone_yocto-core-image-minimal-sdk.sh /tmp/

# Switch to root for installation tasks.
USER root

# Make the SDK installer executable.
RUN chmod +x /tmp/wrlinux-10.24.33.5-glibc-x86_64-beaglebone_yocto-core-image-minimal-sdk.sh

# Unset LD_LIBRARY_PATH and run the installer non-interactively.
RUN unset LD_LIBRARY_PATH && \
    /tmp/wrlinux-10.24.33.5-glibc-x86_64-beaglebone_yocto-core-image-minimal-sdk.sh -y -d /opt/wrlinux-toolchain && \
    rm /tmp/wrlinux-10.24.33.5-glibc-x86_64-beaglebone_yocto-core-image-minimal-sdk.sh

# Add the SDK environment setup to the default shell.
RUN echo 'source /opt/wrlinux-toolchain/environment-setup-cortexa8hf-neon-wrs-linux-gnueabi' >> /etc/profile.d/sdk.sh
ENV PATH="/opt/wrlinux-toolchain/bin:${PATH}"

# ---------------------------
# Additional Configuration for Application
# ---------------------------
# Create directories for your application.
RUN mkdir -p /opt/data/app_manager/config && \
    mkdir -p /opt/data/app_manager/logs && \
    chown -R root:root /opt/data/app_manager

# Enable compiler caching for improved rebuild performance.
ENV USE_CCACHE=1
ENV CCACHE_DIR=/home/user/.ccache

# Set locale.
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8

# ---------------------------
# Final User and Environment Setup
# ---------------------------
# Set default user environment variables.
ENV HOME /home/user
ENV USER user
USER user
WORKDIR /home/user
