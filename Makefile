KERNEL_IMAGE = ./kernelbuild/linux-7.0-rc1/arch/x86/boot/bzImage
KERNEL_BINARY = ./kernelbuild/linux-7.0-rc1/vmlinux
INITRAMFS = ./initramfs.cpio

QEMU_OPTS = -enable-kvm \
		-nographic \
		-m 128M \
		-s \
		-kernel $(KERNEL_IMAGE) \
		-initrd $(INITRAMFS) \
		-append "console=ttyS0 nokaslr quiet"

boot:
	qemu-system-x86_64 $(QEMU_OPTS)

initramfs: install_module
	cd initramfs && find . ! -name ".gitkeep" | cpio -o -H newc --owner=+0:+0 > ../initramfs.cpio

install_module:
	cp ./modules/skels/build/*.ko ./initramfs/lib/modules/

gdb:
	gdb -ex "target remote localhost:1234" $(KERNEL_BINARY)

.PHONY: boot initramfs gdb install_module
