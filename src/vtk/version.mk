PKGROOT            = /opt/vtk
NAME               = vtk
VERSION            = 6.1.0
RELEASE            = 1
TARBALL_POSTFIX    = tar.gz

SRC_SUBDIR         = vtk

SOURCE_NAME        = VTK
SOURCE_VERSION     = $(VERSION)
SOURCE_SUFFIX      = tar.gz
SOURCE_PKG         = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR         = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)

TAR_GZ_PKGS           = $(SOURCE_PKG)
