# Base Image
FROM debian:bullseye

# Install Dependencies
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

# Create User
RUN useradd -m -s /bin/bash user

# Set Working Directory
WORKDIR /home/user

# Copy SDK Installer and Entrypoint Script
COPY wrlinux-10.24.33.5-glibc-x86_64-beaglebone_yocto-core-image-minimal-sdk.sh /tmp/
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Install SDK
RUN chmod +x /tmp/wrlinux-10.24.33.5-glibc-x86_64-beaglebone_yocto-core-image-minimal-sdk.sh && \
    unset LD_LIBRARY_PATH && \
    /tmp/wrlinux-10.24.33.5-glibc-x86_64-beaglebone_yocto-core-image-minimal-sdk.sh -y -d /opt/wrlinux-toolchain && \
    rm /tmp/wrlinux-10.24.33.5-glibc-x86_64-beaglebone_yocto-core-image-minimal-sdk.sh

# Set Permissions for Entrypoint Script
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set Locale
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8

# Set Environment Variables
ENV HOME=/home/user
ENV USER=user
ENV PATH="/opt/wrlinux-toolchain/bin:${PATH}"

# Change to User
USER user

# Set Entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Default Command
CMD ["bash"]
