VERSION.MK.MASTER = version.mk
VERSION.MK.MASTER.DIR = ..
VERSION.MK.INCLUDE = toolkit.version.mk

include $(VERSION.MK.INCLUDE)

PKGROOT         = /opt/cuda/driver
NAME             = cuda-nvidia-driver
VERSION          = $(VERSION_DRIVER)
RELEASE          = 1
DRIVER_INSTALLER = NVIDIA-Linux-x86_64-$(VERSION).run

RPM.FILES = \
/etc/rc.d/init.d/* \n \
/opt/cuda
