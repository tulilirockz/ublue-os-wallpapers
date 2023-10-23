UBLUE_ROOT := /tmp/ublue-os
RPKG_DIR := $(UBLUE_ROOT)/rpkg
TARGET := ublue-os-wallpapers
RPMBUILD := $(UBLUE_ROOT)/rpmbuild

all: build-rpm

spec: output
	rpkg spec --outdir $(RPKG_DIR)

build-rpm:
	rpkg local --outdir $(RPKG_DIR)

xml-files:
	mkdir -p xml
	sh gen-xml-files.sh
