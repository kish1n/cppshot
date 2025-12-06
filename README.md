# cppshot
cppshot is a c++ build system optimized for single file workloads. 
It's primary goals are:
- minimal compile time through integration with C++Modules and precompiled headers
- maximal safety through enabling often overlooked compiler options 
- maximal usability through simple user interface (`b <file>` to build and run, `n <file>` to create a new file with a reasonable template)


Linux Setup:
These tools depends on clang++ and libc++. The BMI for the std module must be built once so it can be referenced in future builds. It can be built through: `clang++ -Wall -Wextra -Wpedantic -Wshadow -std=c++23 -O2 /usr/share/libc++/v1/std.cppm --precompile -o linux_bin/std.pcm -stdlib=libc++`. To create new files with import std, make sure to pass `-m` option when creating a new file.

Example Flow:
`n -m A`: creates a template named A.cpp that uses `import std;` for faster compilation.
`b A`: build and execute A, by default, taking input from a file `in` if it exists in the current directory.


The Windows scripts are not actively maintained and are use-at-your-own-risk.
