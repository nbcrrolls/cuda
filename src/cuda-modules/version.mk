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
CUDANAME        = cuda
RELEASE		= 0
RPM.REQUIRES	= environment-modules
