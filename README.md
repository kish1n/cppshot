# cppshot
cppshot is a c++ build system optimized for single file workloads. 
It's primary goals are:
- minimal compile time through integration with C++ Modules (import std;) and precompiled headers
- maximal safety through default enabling of often overlooked compiler options for static analysis 
- maximal usability through simple user interface (`b <file>` to build and run, `n <file>` to create a new file with a template)


Linux Setup:
The build system depends on the fish shell, clang++ and libc++. The `bin/` folder needs to be added to the PATH env var. This can be done with `fish_add_path /your/path/to/cppshot/bin/`. The BMI for the std module must be built once so it can be referenced in future builds. It can be built through: `clang++ -Wall -Wextra -Wpedantic -Wshadow -std=c++23 -O2 /usr/share/libc++/v1/std.cppm --precompile -o linux_bin/std.pcm -stdlib=libc++`.

Example Flow:
1. `n -m A`: creates a c++ file named A.cpp that uses the `import std;` template for faster compilation.
2. `b A`: build and execute A, by default, taking input from a file `in` if it exists in the current directory.


Performance:
Using the above example flow, the compilation time is 0.04 seconds of the template. When using the template with regular stdlib header files, compilation time is 0.42 seconds, or about 10.5x slower. Recorded on CachyOS with AMD Ryzen 9950X3D CPU @ 5.7GHZ. 
