# Note: normally this package is built with a single compiler, and the rpms
# from multiple compiler builds will overwrite each other.

ifndef ROLLCOMPILER
  ROLLCOMPILER = gnu
endif
COMPILERNAME := $(firstword $(subst /, ,$(ROLLCOMPILER)))

ifndef ROLLMPI
  ROLLMPI = openmpi
endif

ifndef ROLLNETWORK
  ROLLNETWORK = eth
endif

PKGROOT        = /opt/vtk
NAME           = vtk_$(COMPILERNAME)_$(ROLLMPI)_$(ROLLNETWORK)
VERSION        = 6.1.0
RELEASE        = 1

SRC_SUBDIR     = vtk

SOURCE_NAME    = VTK
SOURCE_SUFFIX  = tar.gz
SOURCE_VERSION = $(VERSION)
SOURCE_PKG     = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR     = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)

TAR_GZ_PKGS    = $(SOURCE_PKG)
