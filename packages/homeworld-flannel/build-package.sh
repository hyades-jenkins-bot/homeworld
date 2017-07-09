#!/bin/bash
set -eu

#CHECKSUM="146593fed9dc04b2bb5c194ab0bce7737ee67c04e47b044259ed0a1cdf9743b6986ef5323f959defafce605ddfea1d0acfe91d998d8f05a6f9c7186834532fde"

BIN=../binaries
UPSTREAM=../../upstream
DVERSION="$(head -n 1 debian/changelog | cut -d '(' -f 2 | cut -d ')' -f 1)"
VERSION="$(head -n 1 debian/changelog | cut -d '(' -f 2 | cut -d '-' -f 1)"
mkdir -p "${BIN}"
cp "${UPSTREAM}/flannel-${VERSION}.tar.xz" "flannel-${VERSION}.tar.xz"
if [ ! -e "../go-bin-1.8.3.tgz" ]
then
	echo "No compiled go binaries found." 1>&2
	exit 1
fi
cp "../go-bin-1.8.3.tgz" "go-bin-1.8.3.tgz"
rm -f "../homeworld-flannel_${VERSION}.orig.tar.xz"
ln -s "$(basename $(pwd))/flannel-${VERSION}.tar.xz" "../homeworld-flannel_${VERSION}.orig.tar.xz"
unset GOROOT
sbuild -d stretch
mv "../homeworld-flannel_${DVERSION}_amd64.deb" -t "${BIN}"
#echo "${CHECKSUM}  ${BIN}/homeworld-flannel_${VERSION}_amd64.deb" | sha512sum --check
