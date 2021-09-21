#/!bin/bash

## Specify the port for the SPCIE interface
SPICE_PORT=5924
TELNET_PORT=23

qemu-system-x86_64 \
	-nodefaults \
	-enable-kvm \
	-cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time \
	-smp 2 \
	-m 8G \
	-drive format=raw,file=/dev/sda \
	-boot c \
	-nic user,model=virtio-net-pci \
	-vga qxl \
	-spice port=${SPICE_PORT},disable-ticketing=true \
	-monitor telnet:127.0.0.1:${TELNET_PORT},server,nowait \
	-tpmdev passthrough,id=tpm0,path=/dev/tpm0 \
	-device tpm-tis,tpmdev=tpm0 \
	-object rng-random,filename=/dev/urandom,id=rng0 \
	-device virtio-rng-pci,rng=rng0 \
	-k de \
	-name "Windows" \
	"$@"
#	-usbdevice tablet \
#	-soundhw hda \
#	-daemonize \


## Parameter-explaination
# -nodefaults: remove default configuration, p.ex. a floppy-interface
#	       (wtf, why is there a floppy interface in the fedault configuration?)
# -enable-kvm: enables virtualisation through KVM (kernel virtualised machine) if this module is available
# -cpu host: the host is running on the same cpu-model as the guest. Default-CPU would be "QQemu virtual CPU"
# -smp 2: the amount of CPU-Cores
# -m: The amoung of Memory. "M" and "G" can be used as units for Megabytes ans Gigabytes
# -drive: include a file or device in the VM which is presented as a physical drive to the guest.
#	format=raw: The included device is connected torectly with no translation layer in between.
#		    This option is used for physical drives or partitions
#	file=: the path to the included file / block-device
# -boot: specify the first boot-device. "c" means: boot from the first hard-drive
# -nic: specify network-interface-controller.
#	There are many options. I tried this one and it works
# -vga: specify a graphics-card. "qxl" is recommendet for usage with SPICE
# -spice: enable a SPCIE-interface. Specify the Port via the "port=" parameter
# -monitor: provide a QEMU-Terminal to communicate with the hypervisor.
#	    "telnet" provides a serial terminal via Telnet.
#	    Listening on 127.0.0.1 means that only the host can connect to the Telnet terminal
# -tpmdev: set up a tpm device for windows. The tpm device can be emulated or a pass-through for an existing
#	   device can be used. Use this in combination with the following line:
# -device tpm-tis: provide a TPM-interface following the TPM interface specification.
# -object rng-random: emulate a hardware random number generator. Use as virtio devie with:
# -device virtio-rng-pci: host frontend for the random number generator
# -k: specify Keyboard-Layout
# -name: give the VM a name
## uncommented options:
# -usbdevice tablet: configure the mouse as a touchscreen / tablet and not as a classis mouse.
#		     this improves the interface for the spice client.
# -soundhw hda: add a virtual high definition audio interface to the spice server
# -daemonize: start VM as a daemon in the background
# "$@" add all parameters given to this bash-script as a string to this command. commonly used at the end of the command.



#exec spicy --title Windows 127.0.0.1 -p ${SPICE_PORT}

