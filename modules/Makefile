KMAKEFILE ?= $(shell realpath ../kernelbuild/linux-7.0-rc1/Makefile)

LAB ?= fuck
TODO ?= 0

.PHONY: skels

help:
	@echo "usage: LAB=lab/exersize make skels"
	@echo "example: LAB=kernel_modules/5-oops-mod make skels"
	@echo "make build to build the module"

skels:
	mkdir -p skels
	cd templates/$(LAB) && ls | xargs ../../generate_skels.py --output ../../../skels/ --todo $(TODO)

build:
	make -f $(KMAKEFILE) M=`pwd`/skels MO=`pwd`/skels/build/ modules

clean:
	make -f $(KMAKEFILE) M=`pwd`/skels/ MO=`pwd`/skels/build/ clean

clear:
	rm -rf ./skels/
