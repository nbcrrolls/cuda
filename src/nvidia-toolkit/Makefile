# 
# @Copyright@
# 
# 				Rocks(r)
# 		         www.rocksclusters.org
# 		         version 6.2 (SideWinder)
# 
# Copyright (c) 2000 - 2014 The Regents of the University of California.
# All rights reserved.	
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
# 
# 1. Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
# 
# 2. Redistributions in binary form must reproduce the above copyright
# notice unmodified and in its entirety, this list of conditions and the
# following disclaimer in the documentation and/or other materials provided 
# with the distribution.
# 
# 3. All advertising and press materials, printed or electronic, mentioning
# features or use of this software must display the following acknowledgement: 
# 
# 	"This product includes software developed by the Rocks(r)
# 	Cluster Group at the San Diego Supercomputer Center at the
# 	University of California, San Diego and its contributors."
# 
# 4. Except as permitted for the purposes of acknowledgment in paragraph 3,
# neither the name or logo of this software nor the names of its
# authors may be used to endorse or promote products derived from this
# software without specific prior written permission.  The name of the
# software includes the following terms, and any derivatives thereof:
# "Rocks", "Rocks Clusters", and "Avalanche Installer".  For licensing of 
# the associated name, interested parties should contact Technology 
# Transfer & Intellectual Property Services, University of California, 
# San Diego, 9500 Gilman Drive, Mail Code 0910, La Jolla, CA 92093-0910, 
# Ph: (858) 534-5815, FAX: (858) 534-7345, E-MAIL:invent@ucsd.edu
# 
# THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS''
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# 
# @Copyright@
#

PKGROOT	= /opt/cuda_$(VERSION)
SAMPLES = $(PKGROOT)/samples
UTILS   = $(SAMPLES)/1_Utilities
DISTDIR = distro

REDHAT.ROOT	= $(PWD)/../../
RPM.EXTRAS  = %define __os_install_post /usr/lib/rpm/brp-compress

ARCH = `./_arch`

-include $(ROCKSROOT)/etc/Rules.mk
include Rules.mk

pretar:: $(VERSION.MK.INCLUDE) $(FILES.RPMBASE) $(FILES.RPMLIB) $(FILES.RPMSAMPLES)

$(FILES.RPMBASE):
	echo "RPM.FILES = $(PKGROOT)/*" > $@;

$(FILES.RPMLIB):
	echo "RPM.FILES = $(PKGROOT)/lib64" > $@;

$(FILES.RPMSAMPLES):
	echo "RPM.FILES = $(PKGROOT)/samples" > $@;

$(VERSION.MK.INCLUDE): 
	if [ -f $(VERSION.MK.MASTER.DIR)/$(VERSION.MK.MASTER) ]; then \
		/bin/cp $(VERSION.MK.MASTER.DIR)/$(VERSION.MK.MASTER) $@; \
	fi

build:

install:: 
	# from nvidia distro install toolkit and samples in /opt 
	mkdir -p $(DISTDIR)
	/bin/bash $(TOOLKIT_DISTRO) -extract=`pwd`/$(DISTDIR)
	/bin/bash $(DISTDIR)/cuda-linux*$(VERSION)-*.$(TOOLKIT_SUFFIX) -noprompt -nosymlink -prefix=$(PKGROOT)
	/bin/bash $(DISTDIR)/cuda-samples*$(VERSION)-*.$(TOOLKIT_SUFFIX) -noprompt -prefix=$(SAMPLES) -cudaprefix=$(PKGROOT)

	# apply patch, may not be needed with other versions
	if [ -f $(TOOLKIT_PATCH) ]; then \
		/bin/bash $(TOOLKIT_PATCH) --installdir=$(PKGROOT) --accept-eula --silent; \
	fi

	# compile and install utilities binaries from samples
	(cd $(UTILS)/bandwidthTest; make; cp bandwidthTest $(PKGROOT)/bin )
	(cd $(UTILS)/deviceQuery; make; cp deviceQuery $(PKGROOT)/bin )
	(cd $(UTILS)/deviceQueryDrv; make; cp deviceQueryDrv $(PKGROOT)/bin )
	(cd $(UTILS)/p2pBandwidthLatencyTest; make; cp p2pBandwidthLatencyTest $(PKGROOT)/bin )

	# create samples rpm
	rocks create package $(PKGROOT)/samples $(NAME)-samples version=$(VERSION) release=$(RELEASE) append-version-mk=$(CURDIR)/$(FILES.RPMBASE)
	mkdir -p $(REDHAT.ROOT)/RPMS/$(ARCH)
	mv $(NAME)-samples-*rpm $(REDHAT.ROOT)/RPMS/$(ARCH)
	rm -rf $(PKGROOT)/samples

	# create lib64 rpm
	rocks create package $(PKGROOT)/lib64 $(NAME)-lib64 version=$(VERSION) release=$(RELEASE) append-version-mk=$(CURDIR)/$(FILES.RPMLIB)
	mkdir -p $(REDHAT.ROOT)/RPMS/$(ARCH)
	mv $(NAME)-lib64-*rpm $(REDHAT.ROOT)/RPMS/$(ARCH)
	rm -rf $(PKGROOT)/lib64

	# create remainder of tollkit rpm
	rocks create package $(PKGROOT) $(NAME)-base version=$(VERSION) release=$(RELEASE) append-version-mk=$(CURDIR)/$(FILES.RPMSAMPLES)
	mkdir -p $(REDHAT.ROOT)/RPMS/$(ARCH)
	mv $(NAME)-base-*rpm $(REDHAT.ROOT)/RPMS/$(ARCH)

	# install example commands 
	mkdir -p $(ROOT)/$(PKGROOT)/etc
	$(INSTALL)  nvidia-smi-commands $(ROOT)/$(PKGROOT)/etc
	mkdir -p $(ROOT)/$(PKGROOT)/bin
	$(INSTALL) -m 0755 disable-nouveau $(ROOT)/$(PKGROOT)/bin


clean::
	rm -rf $(VERSION.MK.INCLUDE)
	rm -rf $(FILES.RPMBASE) $(FILES.RPMLIB) $(FILES.RPMSAMPLES)

