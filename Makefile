PORT ?= /dev/ttyACM0
BUILDDIR ?= build
IDF_PATH ?= $(shell pwd)/esp-idf
IDF_EXPORT_QUIET ?= 0
SHELL := /usr/bin/env bash

.PHONY: prepare clean build flash erase monitor menuconfig image

all: prepare build flash

prepare:
	git submodule update --init --recursive
	cd esp-idf; bash install.sh

clean:
	rm -rf "$(BUILDDIR)"

build:
	source "$(IDF_PATH)/export.sh" && idf.py build

flash: build
	source "$(IDF_PATH)/export.sh" && idf.py flash -p $(PORT)

erase:
	source "$(IDF_PATH)/export.sh" && idf.py erase-flash -p $(PORT)

monitor:
	source "$(IDF_PATH)/export.sh" && idf.py monitor -p $(PORT)

menuconfig:
	source "$(IDF_PATH)/export.sh" && idf.py menuconfig

image:
	cd "$(BUILDDIR)"; dd if=/dev/zero bs=1M count=16 of=flash.bin
	cd "$(BUILDDIR)"; dd if=bootloader/bootloader.bin bs=1 seek=4096 of=flash.bin conv=notrunc
	cd "$(BUILDDIR)"; dd if=partition_table/partition-table.bin bs=1 seek=36864 of=flash.bin conv=notrunc
	cd "$(BUILDDIR)"; dd if=main.bin bs=1 seek=65536 of=flash.bin conv=notrunc
