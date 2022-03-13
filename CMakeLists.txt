cmake_minimum_required(VERSION 3.15.3)

project(CubeCM LANGUAGES C ASM)

# across project definitions
set(PROJECT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

set(MCU_MODEL STM32F413xx)
set(MCU_FAMILY STM32F4xx)

set(MCU_FLAGS
  -mcpu=cortex-m4 # CPU
  -mfpu=fpv4-sp-d16 # FPU
  -mfloat-abi=hard # FPU
  -mthumb # Instruction Set
)

### Project Files

# sources
file(GLOB_RECURSE PROJECT_SOURCES
  ${PROJECT_DIR}/*.c
)

# includes
set(PROJECT_INCLUDE_DIRS
  ${CMAKE_CURRENT_SOURCE_DIR}
  ${PROJECT_DIR}
)

### CubeMX Files

set(STARTUP_SCRIPT ${CMAKE_CURRENT_SOURCE_DIR}/startup_stm32f413xx.s)
set(LINKER_SCRIPT ${CMAKE_CURRENT_SOURCE_DIR}/STM32F413ZHTx_FLASH.ld)

# sources
set(STM32CUBEMX_SOURCES
  ${CMAKE_CURRENT_SOURCE_DIR}/Drivers/${MCU_FAMILY}_HAL_Driver/Src/stm32f4xx_hal_tim.c
  ${CMAKE_CURRENT_SOURCE_DIR}/Drivers/${MCU_FAMILY}_HAL_Driver/Src/stm32f4xx_hal_tim_ex.c
  ${CMAKE_CURRENT_SOURCE_DIR}/Drivers/${MCU_FAMILY}_HAL_Driver/Src/stm32f4xx_hal_uart.c
  ${CMAKE_CURRENT_SOURCE_DIR}/Drivers/${MCU_FAMILY}_HAL_Driver/Src/stm32f4xx_hal_rcc.c
  ${CMAKE_CURRENT_SOURCE_DIR}/Drivers/${MCU_FAMILY}_HAL_Driver/Src/stm32f4xx_hal_rcc_ex.c
  ${CMAKE_CURRENT_SOURCE_DIR}/Drivers/${MCU_FAMILY}_HAL_Driver/Src/stm32f4xx_hal_flash.c
  ${CMAKE_CURRENT_SOURCE_DIR}/Drivers/${MCU_FAMILY}_HAL_Driver/Src/stm32f4xx_hal_flash_ex.c
  ${CMAKE_CURRENT_SOURCE_DIR}/Drivers/${MCU_FAMILY}_HAL_Driver/Src/stm32f4xx_hal_flash_ramfunc.c
  ${CMAKE_CURRENT_SOURCE_DIR}/Drivers/${MCU_FAMILY}_HAL_Driver/Src/stm32f4xx_hal_gpio.c
  ${CMAKE_CURRENT_SOURCE_DIR}/Drivers/${MCU_FAMILY}_HAL_Driver/Src/stm32f4xx_hal_dma_ex.c
  ${CMAKE_CURRENT_SOURCE_DIR}/Drivers/${MCU_FAMILY}_HAL_Driver/Src/stm32f4xx_hal_dma.c
  ${CMAKE_CURRENT_SOURCE_DIR}/Drivers/${MCU_FAMILY}_HAL_Driver/Src/stm32f4xx_hal_pwr.c
  ${CMAKE_CURRENT_SOURCE_DIR}/Drivers/${MCU_FAMILY}_HAL_Driver/Src/stm32f4xx_hal_pwr_ex.c
  ${CMAKE_CURRENT_SOURCE_DIR}/Drivers/${MCU_FAMILY}_HAL_Driver/Src/stm32f4xx_hal_cortex.c
  ${CMAKE_CURRENT_SOURCE_DIR}/Drivers/${MCU_FAMILY}_HAL_Driver/Src/stm32f4xx_hal.c
  ${CMAKE_CURRENT_SOURCE_DIR}/Drivers/${MCU_FAMILY}_HAL_Driver/Src/stm32f4xx_hal_exti.c
  ${CMAKE_CURRENT_SOURCE_DIR}/Drivers/${MCU_FAMILY}_HAL_Driver/Src/stm32f4xx_hal_pcd.c
  ${CMAKE_CURRENT_SOURCE_DIR}/Drivers/${MCU_FAMILY}_HAL_Driver/Src/stm32f4xx_hal_pcd_ex.c
  ${CMAKE_CURRENT_SOURCE_DIR}/Drivers/${MCU_FAMILY}_HAL_Driver/Src/stm32f4xx_ll_usb.c

  #  ${CMAKE_CURRENT_SOURCE_DIR}/Core/Inc/main.h
  #  ${CMAKE_CURRENT_SOURCE_DIR}/Core/Inc/stm32f4xx_hal_conf.h
  #  ${CMAKE_CURRENT_SOURCE_DIR}/Core/Inc/stm32f4xx_it.h

  ${CMAKE_CURRENT_SOURCE_DIR}/Core/Src/main.c
  ${CMAKE_CURRENT_SOURCE_DIR}/Core/Src/stm32f4xx_it.c
  ${CMAKE_CURRENT_SOURCE_DIR}/Core/Src/stm32f4xx_hal_msp.c
  ${CMAKE_CURRENT_SOURCE_DIR}/Core/Src/system_stm32f4xx.c
)

# includes
set(CUBEMX_INCLUDE_DIRS
  ${CMAKE_CURRENT_SOURCE_DIR}/Core/Inc
  ${CMAKE_CURRENT_SOURCE_DIR}/Drivers/${MCU_FAMILY}_HAL_Driver/Inc
  ${CMAKE_CURRENT_SOURCE_DIR}/Drivers/${MCU_FAMILY}_HAL_Driver/Inc/Legacy
  ${CMAKE_CURRENT_SOURCE_DIR}/Drivers/CMSIS/Device/ST/${MCU_FAMILY}/Include
  ${CMAKE_CURRENT_SOURCE_DIR}/Drivers/CMSIS/Include
)

### Executable

set(EXECUTABLE ${PROJECT_NAME}.elf)

add_executable(${EXECUTABLE}
  ${STARTUP_SCRIPT}
  ${STM32CUBEMX_SOURCES}
  ${PROJECT_SOURCES}
)

target_compile_definitions(${EXECUTABLE} PRIVATE
  -DUSE_HAL_DRIVER
  -D${MCU_MODEL}
)

target_include_directories(${EXECUTABLE} PRIVATE
  ${CUBEMX_INCLUDE_DIRS}
  ${PROJECT_INCLUDE_DIRS}
)

target_compile_options(${EXECUTABLE} PRIVATE
  ${MCU_FLAGS}

  -fdata-sections
  -ffunction-sections

  -Wall
  -Wextra
  -Wpedantic

  $<$<CONFIG:Debug>:-Og -g3>
)

target_link_options(${EXECUTABLE} PRIVATE
  -T${LINKER_SCRIPT}
  ${MCU_FLAGS}

  # generate a map file for debugging purposes
  -Wl,-Map=${CMAKE_PROJECT_NAME}.map,--cref

  # garbage collect unused sections (see also -ffunction-sections and -fdata-sections in compile options)
  -Wl,--gc-sections

  --specs=nano.specs

  # add some C libraries
  -Wl,--start-group
  -lnosys
  -lc
  -lm
  -Wl,--end-group

  # pretty print memory usage. goes well along with size command
  -Wl,--print-memory-usage
)

add_custom_command(TARGET ${EXECUTABLE}
  POST_BUILD
  COMMAND ${CMAKE_SIZE_UTIL} ${EXECUTABLE}
)

string(REPLACE ".elf" ".bin" BIN_EXECUTABLE ${EXECUTABLE})
string(REPLACE ".elf" ".hex" HEX_EXECUTABLE ${EXECUTABLE})

add_custom_command(TARGET ${EXECUTABLE}
  POST_BUILD
  COMMAND ${CMAKE_OBJCOPY} -O ihex ${EXECUTABLE} ${HEX_EXECUTABLE}
  COMMAND ${CMAKE_OBJCOPY} -O binary ${EXECUTABLE} ${BIN_EXECUTABLE}
)
