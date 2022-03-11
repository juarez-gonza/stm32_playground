.PHONY: all build cmake clean flash

BUILD_DIR := .\build
BUILD_TYPE ?= Debug

PROJECT_NAME := CubeCM

FLASH_ADDR := 0x08000000

all: flash

${BUILD_DIR}/Makefile:
	cmake \
		-B${BUILD_DIR} \
		-DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
		-DCMAKE_TOOLCHAIN_FILE=gcc-arm-none-eabi.cmake \
		-DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
		-G "Unix Makefiles"

cmake: ${BUILD_DIR}/Makefile

build: cmake
	cmake --build ${BUILD_DIR}

flash: build
	st-flash --reset write ${BUILD_DIR}/${PROJECT_NAME}.bin ${FLASH_ADDR}

clean:
	cmake --build ${BUILD_DIR} --target clean
