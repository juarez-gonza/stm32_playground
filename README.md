# CLI Usage

## Compilation

Install the software listed in .software.list  
Poistion yourself at the root directory of this repository and run `make build`

### alternative
using CMake GUI or configuring your IDE compilation command to run the above command

## Static Analysis

Install the software listed in .software.list under static analysis

Run at least `make cmake` (running just `make` and `make build` also run `make cmake` for you)  
Then, if positioned at the root directory of this repository:  
run `CodeChecker analyze build/compile_commands.json -o reports/`

## Flashing
Poistion yourself at the root directory of this repository and run `make`

### alternative
Use CubeProgrammer, st-link gui
