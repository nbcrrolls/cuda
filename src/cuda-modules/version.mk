# Get the Openmpi version from it's version.mk file. See Makefile
VERSION.MK.MASTER = version.mk
VERSION.MK.MASTER.DIR = ..
VERSION.MK.INCLUDE = toolkit.version.mk

#VERSION.MK.MASTER.DIR = ../nvidia-toolkit
#VERSION.MK.DRIVER.DIR = ../nvidia-driver
#VERSION.MK.INCLUDE = toolkit.version.mk

include $(VERSION.MK.INCLUDE) 
NAME		= cuda-module$(TOOLKIT_SHORT)
VERSION         = $(VERSION_TOOLKIT)
RELEASE		= 0
CUDANAME        = cuda
PKGROOT 	= /usr/share/Modules/modulefiles
MODULE_DEST	= $(PKGROOT)
RPM.REQUIRES	= environment-modules
RPM.FILES = \
/etc/modprobe.d/* \n \
$(MODULE_DEST)/cuda
