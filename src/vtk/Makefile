#
# $Id$
#
# @Copyright@
#
# 				Rocks(r)
# 		         www.rocksclusters.org
# 		         version 7.0 (Manzanita)
#
# Copyright (c) 2000 - 2017 The Regents of the University of California.
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

REDHAT.ROOT = $(CURDIR)/../../

-include $(ROCKSROOT)/etc/Rules.mk
include Rules.mk
include $(SDSCDEVEL)/Pull.mk
include $(SDSCDEVEL)/Rules.mk

# Assume openmpi, test for mvapich2
MPILIBS = -L$${MPIHOME}/lib -lmpi -libverbs -lrt -lnsl -lutil -ldl -lm -lrt -lnsl -lutil
ifneq ("$(ROLLMPI)", "$(subst mvapich2,,$(ROLLMPI))")
  MPILIBS = -L$${MPIHOME}/lib -lmpich -lopa -lmpl -libmad -lrdmacm -libumad -libverbs -lrt -lhwloc -llimic2 -lpthread -lhwloc
endif

$(NAME).spec: DESCRIPTION LICENSE

DESCRIPTION:
	$(MODULE_LOAD_CC); \
	$(MODULE_LOAD_PYTHON); \
	( \
	  $(DESCRIBE_PKG); \
	  $(DESCRIBE_CC); \
	  $(DESCRIBE_MPI); \
	  $(DESCRIBE_PYTHON) \
	) > $@

LICENSE: $(SRC_DIRS)
	$(CHECK_LICENSE_FILES)
	echo -e BSD > $@

build: $(SRC_DIRS)
	mkdir $(SOURCE_DIR)/build
	( \
	  $(MODULE_LOAD_CC); \
	  $(MODULE_LOAD_MPI); \
	  $(MODULE_LOAD_CMAKE); \
	  $(MODULE_LOAD_PYTHON); \
	  pyvers=`python --version 2>&1 | grep -o '[0-9][0-9]*\.[0-9][0-9]*'`; \
	  PYHOME=`which python | sed "s/\/bin.*//"`; \
	  PYTHON_INCLUDE_DIR=$$PYHOME/include/python$${pyvers}; \
	  PYTHON_LIBRARY=`find $$PYHOME -name libpython$${pyvers}.so | head -1`; \
	  export MPILIBS="$(MPILIBS)"; \
	  if test -e $${MPIHOME}/lib/libmpi_cxx.a; then \
	    export MPILIBS=`echo $$MPILIBS | sed 's/-lmpi/-lmpi_cxx -lmpi/'`; \
	  fi; \
	  cd $(SOURCE_DIR)/build; \
	  cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$(PKGROOT) \
	        -DBUILD_SHARED_LIBS=ON -DBUILD_TESTING=ON \
	        -DVTK_WRAP_PYTHON=ON -DVTK_WRAP_TCL=ON -DVTK_WRAP_JAVA=ON \
	        -DPYTHON_INCLUDE_DIR=$$PYTHON_INCLUDE_DIR \
	        -DPYTHON_LIBRARY=$$PYTHON_LIBRARY \
	        -DVTK_Group_MPI=ON -DMPI_C_LIBRARIES="$${MPILIBS}"\
	        -DMPI_CXX_INCLUDE_PATH=$${MPIHOME}/include \
	        -DMPI_CXX_LIBRARIES="$${MPILIBS}" \
	        -DCMAKE_C_FLAGS=-DGLX_GLXEXT_LEGACY \
	        -DCMAKE_CXX_FLAGS=-DGLX_GLXEXT_LEGACY \
	        ..; \
	  $(MAKE) \
	)
	@echo "::: Package $(NAME) build complete :::"
	
install::
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)
	$(PKGROOT_BIND_MOUNT)
	( \
	  cd $(SOURCE_DIR)/build; \
	  $(MAKE) install \
	)
	$(PKGROOT_BIND_UMOUNT)
	$(INSTALL_LICENSE_FILES)
	@echo "::: Package $(NAME) install complete :::"

clean::
	rm -rf $(SOURCE_DIR) DESCRIPTION LICENSE
