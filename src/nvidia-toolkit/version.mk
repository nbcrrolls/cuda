VERSION.MK.MASTER = cuda.mk
VERSION.MK.MASTER.DIR = ../..
VERSION.MK.INCLUDE = toolkit.version.mk
include $(VERSION.MK.INCLUDE)

FILES.RPMBASE    = toolkit-base-$(VERSION).files  
FILES.RPMLIB     = toolkit-lib64-$(VERSION).files  
FILES.RPMSAMPLES = toolkit-samples-$(VERSION).files 

NAME    = cuda-toolkit$(TOOLKIT_SHORT)
VERSION = $(VERSION_TOOLKIT)
RELEASE = 0

# directory name to extract distribution files into and a distribution version string
DISTDIR = distro
DISTRO  = 8.0.61_375.26

TOOLKIT_ARCH   = linux
TOOLKIT_SUFFIX = run

# dsitro source for version 7*
#TOOLKIT_DISTRO = cuda_$(VERSION)_$(TOOLKIT_ARCH).$(TOOLKIT_SUFFIX)

# distro source for version 8*
TOOLKIT_DISTRO = cuda_$(DISTRO)_$(TOOLKIT_ARCH)-$(TOOLKIT_SUFFIX)
# patch file
TOOLKIT_PATCH  = cuda_$(VERSION).2_$(TOOLKIT_ARCH)-$(TOOLKIT_SUFFIX)

RPM.FILES = \
/opt/cuda_$(VERSION)/etc/* \n \
/opt/cuda_$(VERSION)/bin/disable-nouveau 
