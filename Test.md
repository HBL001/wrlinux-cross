## Simple Test Process

To verify that your cross-compiler is properly set up and functioning within your Docker container, you can perform a simple test by compiling a basic "Hello, World!" program. Here's how you can do it:

    Create a Test Directory and Source File:

    Open a terminal and execute the following commands:

```
mkdir -p ~/cross-compile-test
cd ~/cross-compile-test
```

Then, create a simple C++ source file named hello.cpp with the following content:

```
#include <iostream>

int main() {
    std::cout << "Hello, World!" << std::endl;
    return 0;
}
```

Compile the Source File Using the Cross-Compiler:

Assuming you've already set up your Docker container with the Wind River cross-compiler and have sourced the environment setup script, compile the hello.cpp file:

```
arm-wrs-linux-gnueabi-g++ --sysroot=/opt/wrlinux-toolchain/sysroots/armv7at2hf-neon-wrs-linux-gnueabi hello.cpp -o hello


arm-wrs-linux-gnueabi-g++ hello.cpp -o hello
```

This command invokes the cross-compiler to compile the source code into an executable named hello.

Verify the Compiled Executable:

After compilation, you can check the type of the generated executable to ensure it's built for the correct architecture:

file hello

The output should indicate that the executable is for the ARM architecture, something like:

```
hello: ELF 32-bit LSB executable, ARM, EABI5 version 1 (SYSV), dynamically linked, interpreter /lib/ld-linux.so.3, for GNU/Linux 3.2.0, not stripped
```

This confirms that the cross-compilation was successful and the compiler is functioning as expected.
