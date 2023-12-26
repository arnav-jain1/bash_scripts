# Bash Scripts that I created and use a lot
To use I suggest creating an alias in .bashrc, suggest aliases are shown in examples

## compile.sh
Runs the compile commands for c++ and c files \
Arguments:
* -r: Runs the file(s)
* -a: Outputs the assembly code of the file(s)
* -t: Times the compilation of the file(s)
* -m: Runs valgrind on the output file 

It will compile the specified file/folder or if no file/folder provided, it compiles the current folder \
Automatically differentiates between C and C++ files \
NOTE: DOES NOT REPLACE MAKEFILES, mainly created for my small C/C++ assignments \
Usage:
* compile -at 
  * Times compilation of program and outputs assembly file of current directly
* compile -rm test.c
  * Compiles, runs, and memory checks test.c
* compile -rmat test/
  * Compiles, times, runs, memory checks, and gets assembly of test/ directory
* compile hello.cpp
  * Compiles hello.cpp


## brightness.sh
Sets the brightness on your computer \
Has the following flags:
* -m: Gets the max brightness of computer
  * bn -m
* -n: Can change the numeric value of the brightness 
  * bn -n +5 (changes the brightness unit by +5)
  * bn -n -5
  * bn -n 1000 (Sets brightness unit to 1000)
* None: Changes the percentage value of the brightness
  * bn +5 (+5% brightness)
  * bn -5 (-5% brightness)
  * bn 5 (Sets brightness to 5%)

Note: Built in minimum brightness value to make sure you can't make it too low

## clean.sh
Remove all files with o, exe, out, and no extensions in current or specified directory \
Saves all the files in arguments \
Usage:
* clean /test main.exe
  * Cleans files in /test except main.exe
* clean test 
  * Cleans files in current directory except test

## battery.sh
Logs the battery percentage every 15 seconds because my battery life sucks \
Just run it on startup and let it run in the background \
To see the tracking look into log.txt in the same folder as the battery.sh file \
Usage:
* track

### Side note
For all typos, changes, issues, bugs, and whatnot submit a pull request or issue. \ 
Future plans:
* Assembly to executable for compile.sh
* Flags for clean.sh to specify extensions to remove or save
* Basic Spotify control (not likely)