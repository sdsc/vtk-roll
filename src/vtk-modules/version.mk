NAME        = vtk-modules
RELEASE     = 0
PKGROOT     = /opt/modulefiles/applications/vtk

VERSION_SRC = $(REDHAT.ROOT)/src/vtk/version.mk
VERSION_INC = version.inc
include $(VERSION_INC)

RPM.EXTRAS  = AutoReq:No
