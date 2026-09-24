CC=arm-none-eabi-gcc
TARGET=flash

MACH=-mcpu=cortex-m4
FLOAT=-mfloat-abi=soft

BUILD_DIR = Build
ROOT_DIR = .
LINKER= -T $(ROOT_DIR)/STM32F411.ld
MAP_FILE= -Wl,-Map=$(BUILD_DIR)/$(TARGET).map

CFLAGS= -c $(MACH) -mthumb $(FLOAT) -std=gnu99 -Wall -O0 \
		-nostdlib -ffunction-sections -fdata-sections

LDFLAGS = $(MACH) -mthumb $(FLOAT) -nostdlib $(LINKER) $(MAP_FILE) \
			-Wl,--gc-sections -static --specs=nano.specs -Wl,--start-group -lc -lm \
			-Wl,--end-group -Wl,--print-memory-usage

OBJCOPY=arm-none-eabi-objcopy

############################################
# 				SOURCE FILES
############################################

OBJS		+= $(BUILD_DIR)/main.o
OBJS		+= $(BUILD_DIR)/function.o


PREREQ = $(BUILD_DIR)/

all: $(PREREQ) $(BUILD_DIR)/$(TARGET).elf

$(PREREQ):
	mkdir $(PREREQ)

$(BUILD_DIR)/%.o: $(ROOT_DIR)/%.s
	$(CC) $(CFLAGS) $(INCLUDES) -o $(BUILD_DIR)/$(*).o $(ROOT_DIR)/$(*).s

$(BUILD_DIR)/%.o: $(ROOT_DIR)/%.c
	$(CC) $(CFLAGS) $(INCLUDES) -o $(BUILD_DIR)/$(*).o $(ROOT_DIR)/$(*).c

# TARGET ELF
$(BUILD_DIR)/$(TARGET).elf: $(OBJS) 
	$(CC) $(LDFLAGS) -o $@ $^
	$(OBJCOPY) -O binary $(BUILD_DIR)/$(TARGET).elf $(BUILD_DIR)/$(TARGET).bin
	arm-none-eabi-size $(BUILD_DIR)/$(TARGET).elf

load:
	openocd -f interface/jlink.cfg -c "transport select swd" -f target/stm32f4x.cfg -c init -c "reset init" \
	-c "flash write_image erase Build/$(TARGET).elf" -c "reset run" -c shutdown

clean:
	rm -rf $(BUILD_DIR)/*.map $(BUILD_DIR)/*.o
