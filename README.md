# CLI Usage

Windows: USE POWERSHELL (not cmd)  
Linux: There are no shell commands out of Makefiles at the moment but there is an attempt to keep it
POSIX compliant (i.e.: no bashisms or whatever zsh-isms are called)  

## Compilation

After installing the necessary software
Poistion yourself at the root directory of this repository and run `make build`

### alternative
* CMake GUI
* Configuring your IDE compilation and/or launch command to run the above command

## Static Analysis

Install the software listed in .software.list under static analysis

Run at least `make cmake` (running just `make` and `make build` also run `make cmake` for you)
Then, if positioned at the root directory of this repository:
run `CodeChecker analyze build/compile_commands.json -o reports/`

## Flashing
Poistion yourself at the root directory of this repository and run `make`

### alternatives
* CubeProgrammer
* st-link gui

## Debug
OpenOCD or st-util as gdb-server, arm-none-eabi-gdb to attach.
Both openOCD and st-util integrate well with vscode.

# LIST OF TOOLS

## Compilation toolchain
* cmake (for windows users installing from chocolatey, also install cmake Graphical UI) - NEEDED

* gnu make - NEEDED

* gcc-arm-none-eabi - NEEDED

## static analysis
* CodeChecker (https://codechecker.readthedocs.io/en/latest/) - NEEDED BY DEVELOPERS

* clang, clang-format, clang-tidy, clang static analyzer (Clang & clang-tools-extra at https://releases.llvm.org/download.html) - NEEDED BY DEVELOPERS

## flash to board
* st-link (https://github.com/stlink-org/stlink) - NEEDED FOR Command Line FLASH (done automatically with root Makefile)
  * st-flash
  * stlink-gui

### Graphical UI alternative
* STM32CubeProgrammer (https://www.st.com/en/development-tools/stm32cubeprog.html#overview)

## initial project generator (HAL, BSP, startup scripts), pinout, clock config & general project configs
* STM32CubeMX (https://www.st.com/en/development-tools/stm32cubemx.html) - NEEDED

## Debug
* arm-none-eabi-gdb - NEEDED

* st-link (https://github.com/stlink-org/stlink) - NEEDED
  * st-util (GDB Server) (CLI, can be set for VSCode. plenty of tutorials online and on youtube)
  * stlink-gui

### alternative to st-util as gdb server
openocd (this is very much documented as is widely used in the embedded world)
  example linux: https://www.youtube.com/watch?v=_1u7IOnivnM (might need to setup udev rules https://openocd.org/doc/html/Running.html)
  example windows: https://www.youtube.com/watch?v=PxQw5_7yI8Q&t

# WINDOWS DEPENDENCY DOWNLOADS

## chocolatey package manager
(Instructions for Chocolatey Installation: https://www.youtube.com/watch?v=-5WLKu_J_AE).  
installations can be done manually via the links provided on each item (please read the NOTE,
such as the current CMake note). Another option is to use the `install_script.ps1`, this command will attempt
to recognize if a program exists or not, and install it via chocolatey if not found on the system
(just beware I learnt powershell scripting for this sole purpose at 1am in the morning):

## PROGRAM LIST

### PROGRAM LIST: CHOCOLATEY  


    * git (https://community.chocolatey.org/packages/git.install)
			check installation command: git --version

    * mingw (https://community.chocolatey.org/packages/mingw)
			check installation command: gcc.exe --version

    * gcc-arm-embedded (https://community.chocolatey.org/packages/gcc-arm-embedded)
			check installation command: arm-none-eabi-gcc.exe --version

    * cmake (https://community.chocolatey.org/packages/cmake/3.22.1).
			check installation command: cmake --version
	  	NOTE: if on chocolatey: remember to add to path when installing
	  	example command:  `choco install cmake --version 3.22.1 --installargs 'ADD_CMAKE_TO_PATH=System'`

    * GNU make (https://community.chocolatey.org/packages/make)
			check installation command: make --version

    * Clang and tools (https://community.chocolatey.org/packages/llvm).
			check installation command: clangd --version

    * python3 (3.6 or higher) (https://community.chocolatey.org/packages/python3/3.10.2)
			check installation command: python --version  


		As remarked previously, this can be installed manually with the links. Or open a powershell, position yourself at the root
		of this repository (where this README.md lies) and run the following commands:
		```
		set-executionpolicy remotesigned
		.\install_script.ps1
		```

### PROGRAM LIST: OUT OF CHOCOLATEY

* st-link tools (download windows x86_64 - doubt you have a 32bit machine- from https://github.com/stlink-org/stlink/releases/tag/v1.7.0)

* codechecker `pip3 install codechecker`
  * NOTES:
    * might need to run the command as root
    * might need to install microsoft visual c++ 14.0 or higher if you don't already have it. For that you may install
		visual studio 2017 from https://visualstudio.microsoft.com/thank-you-downloading-visual-studio/?sku=BuildTools&rel=15
		or just google for a newer version of visual studio.
		On installation, check only "Visual C++ BuildTools", with "Windows 10 SDK" checked on the "Installation Details" right-side panel
		(the other Installation Details options don't matter for this, include them if you want).
		More info at https://stackoverflow.com/questions/52383577/installing-ms-c-14-0-for-python-without-visual-studio#:~:text=To%20install%20MS%20C%2B%2B%2014.0%20only%3A%20download%20visualcppbuildtools_full.exe,restart%20pc%20and%20you%20are%20up%20to%20it.

# Linux

On your own for this one. Too many package managers to cover. But in general it is
easy to setup.

# BSDs

idem linux
