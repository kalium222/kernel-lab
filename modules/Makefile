KMAKEFILE ?= $(shell realpath ../kernelbuild/linux-7.0-rc1/Makefile)

LAB ?= fuck
TODO ?= 0

BUILD_DIR := $(shell pwd)/skels/build

.PHONY: skels

help:
	@echo "usage: LAB=lab/exersize make skels"
	@echo "example: LAB=kernel_modules/5-oops-mod make skels"
	@echo "make build to build the module"

skels:
	mkdir -p skels
	cd templates && find $(LAB) -type f | xargs ./generate_skels.py --output ../skels --todo $(TODO)

build:
	@for i in $(shell find skels -name Kbuild | xargs -r dirname); do \
		make -f $(KMAKEFILE) M=$$i MO=$(BUILD_DIR) modules; \
	done

clean:
	@for i in $(shell find skels -name Kbuild | xargs -r dirname); do \
		make -f $(KMAKEFILE) M=$$i MO=$(BUILD_DIR) clean; \
	done

clean_skels:
	rm -rf skels
