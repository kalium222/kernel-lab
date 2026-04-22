KERNEL_IMAGE = ./kernelbuild/linux-7.0-rc1/arch/x86/boot/bzImage
KERNEL_BINARY = ./kernelbuild/linux-7.0-rc1/vmlinux
INITRAMFS = ./initramfs.cpio

GRAPHIC ?= 0
ifeq ($(GRAPHIC),0)
    DISPLAY_OPTS = -nographic
    CONSOLE_OPTS = console=ttyS0
else
    DISPLAY_OPTS =
    CONSOLE_OPTS =
endif

QEMU_OPTS = -enable-kvm \
		-m 128M \
		-s \
		-kernel $(KERNEL_IMAGE) \
		-initrd $(INITRAMFS) \
		$(DISPLAY_OPTS) \
		-append "$(CONSOLE_OPTS) nokaslr quiet"

boot:
	qemu-system-x86_64 $(QEMU_OPTS)

initramfs: install_module
	cd initramfs && find . ! -name ".gitkeep" | cpio -o -H newc --owner=+0:+0 > ../initramfs.cpio

install_module:
	cp ./modules/skels/build/*.ko ./initramfs/lib/modules/

gdb:
	gdb -ex "target remote localhost:1234" $(KERNEL_BINARY)

.PHONY: boot initramfs gdb install_module
