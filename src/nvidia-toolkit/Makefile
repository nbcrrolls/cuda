# 
# $Id: Makefile,v 1.1 2011/10/12 21:59:48 nadya Exp $
#
# @Copyright@
# @Copyright@
#
# $Log: Makefile,v $
# Revision 1.1  2011/10/12 21:59:48  nadya
# initial, based on hg-rocks5.3 cuda roll.
#

PKGROOT	= /opt/cuda
SAMPLES = $(PKGROOT)/samples
UTILS   = $(SAMPLES)/1_Utilities
DISTDIR = distro

REDHAT.ROOT	= $(PWD)/../../
RPM.EXTRAS  = %define __os_install_post /usr/lib/rpm/brp-compress

ARCH = `./_arch`

-include $(ROCKSROOT)/etc/Rules.mk
include Rules.mk

build:
	# install toolkit and samples in /opt 
	mkdir -p $(DISTDIR)
	/bin/bash cuda_6.5.14_linux_64.run -extract=`pwd`/$(DISTDIR)
	/bin/bash $(DISTDIR)/cuda-linux*$(VERSION)-*.$(TOOLKIT_SUFFIX) -noprompt -nosymlink -prefix=$(PKGROOT)
	/bin/bash $(DISTDIR)/cuda-samples*$(VERSION)-*.$(TOOLKIT_SUFFIX) -noprompt -prefix=$(SAMPLES) -cudaprefix=$(PKGROOT)
	# create samples rpm
	rocks create package $(PKGROOT)/samples $(NAME)-samples version=$(VERSION) release=$(RELEASE)
	mkdir -p $(REDHAT.ROOT)/RPMS/$(ARCH)
	mv $(NAME)-samples-*rpm $(REDHAT.ROOT)/RPMS/$(ARCH)
	# compile and install utilities binaries in samples
	(cd $(UTILS)/bandwidthTest; make; cp bandwidthTest $(PKGROOT)/bin )
	(cd $(UTILS)/deviceQuery; make; cp deviceQuery $(PKGROOT)/bin )
	(cd $(UTILS)/deviceQueryDrv; make; cp deviceQueryDrv $(PKGROOT)/bin )
	(cd $(UTILS)/p2pBandwidthLatencyTest; make; cp p2pBandwidthLatencyTest $(PKGROOT)/bin )
	rm -rf $(PKGROOT)/samples
	# create lib64 rpm
	rocks create package $(PKGROOT)/lib64 $(NAME)-lib64 version=$(VERSION) release=$(RELEASE)
	mkdir -p $(REDHAT.ROOT)/RPMS/$(ARCH)
	mv $(NAME)-lib64-*rpm $(REDHAT.ROOT)/RPMS/$(ARCH)
	rm -rf $(PKGROOT)/lib64
	# create remainder of tollkit rpm
	rocks create package $(PKGROOT) $(NAME)-base version=$(VERSION) release=$(RELEASE)
	mkdir -p $(REDHAT.ROOT)/RPMS/$(ARCH)
	mv $(NAME)-base-*rpm $(REDHAT.ROOT)/RPMS/$(ARCH)
	rm -rf $(PKGROOT)

install:: 
	#mkdir -p $(ROOT)/etc/ld.so.conf.d
	#mkdir -p $(ROOT)/etc/profile.d
	#install -m755 cuda.sh  $(ROOT)/etc/profile.d/
	#install -m755 cuda.csh $(ROOT)/etc/profile.d/
	#echo $(PKGROOT)/lib64 > $(ROOT)/etc/ld.so.conf.d/cuda.conf
	#mkdir -p $(ROOT)/$(PKGROOT)/bin
