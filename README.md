# Simple linux kernel env
## Build kernel
Build linux kernel in `./kernelbuild/`. The path should look like `./kernelbuild/linux-7.0-rc1/Makefile`.
See [arch wiki](https://wiki.archlinux.org/title/Kernel/Traditional_compilation).
### Kernel config
use default config, enable kvm_guest, and enable debug, see [document](https://www.kernel.org/doc/html/latest/process/debugging/gdb-kernel-debugging.html).
```
$ make distclean
$ make defconfig
$ make kvm_guest.config
$ make xconfig              # enable debug in qt gui
$ make oldconfig
```
### Set clangd

After building the kernel, run `path/to/kerneltree/scripts/clang-tools/gen_compile_commands.py`
## Make busybox initramfs
In `initramfs`, 
```
$ mkdir bin etc etc/init.d
```
Create `etc/inittab`, where
```
::sysinit:/etc/init.d/rcS
::once:-sh -c 'cat /etc/motd; setsid cttyhack setuidgid 0 /bin/sh; poweroff'
```
Create `/etc/init.d/rcS`, where
```
#!/bin/sh

mkdir -p /proc && mount -t proc none /proc
mkdir -p /sys && mount -t sysfs none /sys
mkdir -p /dev && mount -t devtmpfs devtmpfs /dev
mkdir -p /tmp && mount -t tmpfs tmpfs /tmp
```
make it executable `chmod +x rcS`.  
Download the `busybox` binary, put it in the `bin` and create softlinks:
```
# in bin/
./busybox --list | xargs -n1 -P8 ln -s busybox
```
Create the initramfs:
```
# in initramfs/
find . | cpio -o -H newc --owner=+0:+0 > ../initramfs.cpio
```
## Qemu
check `Makefile` and [qemu doc](https://www.qemu.org/docs/master/system/gdb.html).
