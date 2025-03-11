#!/bin/bash
#
echo "Setting up Wind River Linux cross-compilation environment..."

# Step 1: Source the Wind River Linux SDK environment
unset LD_LIBRARY_PATH
export SDK_ROOT="/opt/windriver/wrlinux/24.33"
source $SDK_ROOT/environment-setup-cortexa8hf-neon-wrs-linux-gnueabi

# Step 2: Ensure correct sysroot is set
export SYSROOT="$SDK_ROOT/sysroots/cortexa8hf-neon-wrs-linux-gnueabi"

# Step 3: Force the correct compiler settings
export CC="arm-wrs-linux-gnueabi-gcc --sysroot=$SYSROOT -mcpu=cortex-a8 -mfpu=neon -mfloat-abi=hard"
export CXX="arm-wrs-linux-gnueabi-g++ --sysroot=$SYSROOT -mcpu=cortex-a8 -mfpu=neon -mfloat-abi=hard"
export CPPFLAGS="--sysroot=$SYSROOT -I$SYSROOT/usr/include/c++/13.3.0 -I$SYSROOT/usr/include/c++/13.3.0/arm-wrs-linux-gnueabi"
export LDFLAGS="--sysroot=$SYSROOT"
#
echo "Wind River Linux environment configured!"


