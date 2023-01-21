#!/bin/sh

export VM="FreeBSD"
export UEFIVARS="OVMF_VARS.fd"
export HD="freebsd_current.qcow2"
export MAC="GENERATED.MAC"
export SSHPORT="SSH.PORT.TO.USE"
export BOOTCD="INSTALLATION.IMAGE"

# Initiate OS installation
#	-boot menu=on -drive file=${BOOTCD},media=cdrom \

exec qemu-system-x86_64 -accel kvm \
	-name ${VM} \
	-cpu host -smp sockets=1,cores=8,threads=1 \
	-m 8192 \
	-drive file=/usr/share/edk2-ovmf/x64/OVMF_CODE.fd,format=raw,if=pflash,readonly=on \
	-drive file=${UEFIVARS},format=raw,if=pflash \
	-drive file=${HD},format=qcow2,if=virtio \
	-netdev user,id=net0,ipv6=off,hostfwd=tcp::${SSHPORT}-:22 -device virtio-net-pci,netdev=net0,mac=${MAC} \
	-audiodev pa,id=snd0 -device intel-hda -device hda-output,audiodev=snd0 \
	-display sdl -vga vmware \
	-usbdevice keyboard -usbdevice tablet \
	-rtc base=utc,clock=host -no-hpet \
	-monitor stdio \
	-nodefaults \
	"$@"
