#!/bin/bash
set -e -u
cd "$(dirname "$0")"
source ../common/container-build-helpers.sh

FLANNEL_VER="0.8.0"
REVISION="3"
VERSION="${FLANNEL_VER}-${REVISION}"

DEBVER="stretch.20171004T154711Z"
BUILDVER="stretch.20171004T154711Z"
UPDATE_TIMESTAMP="2017-10-04T14:41:00-0400"

common_setup

# build flannel

init_builder
build_with_go

GODIR="${BUILDDIR}/gosrc"
rm -rf "${GODIR}"
COREOS="${GODIR}/src/github.com/coreos"
mkdir -p "${COREOS}"

tar -C "${COREOS}" -xf "${UPSTREAM}/flannel-${FLANNEL_VER}.tar.xz" "flannel-${FLANNEL_VER}/"
mv "${COREOS}/flannel-${FLANNEL_VER}" -T "${COREOS}/flannel"

build_at_path "${COREOS}/flannel"

run_builder "go build -o dist/flanneld -ldflags '-X github.com/coreos/flannel/version.Version=${FLANNEL_VER}'"

# build container

start_acbuild_from "debian-mini" "${DEBVER}"
$ACBUILD copy "${COREOS}/flannel/dist/flanneld" /usr/bin/flanneld
add_packages_to_acbuild iptables
$ACBUILD set-exec -- /usr/bin/flanneld
finish_acbuild
