#!/bin/bash
VERSION="1.4.4"
curl -o hashicorp.gpg https://keybase.io/hashicorp/pgp_keys.asc?fingerprint=91a6e7f85d05c65630bef18951852d87348ffc4c
gpg --import hashicorp.gpg
curl -O https://releases.hashicorp.com/packer/${VERSION}/packer_${VERSION}_linux_amd64.zip
curl -O https://releases.hashicorp.com/packer/${VERSION}/packer_${VERSION}_SHA256SUMS
curl -O https://releases.hashicorp.com/packer/${VERSION}/packer_${VERSION}_SHA256SUMS.sig
gpg --verify packer_${VERSION}_SHA256SUMS.sig packer_${VERSION}_SHA256SUMS
# remove other sha sums from the checksums file to avoid erroring on
# missing files (sha256sum --ignore-missing doesn't work in this version
# of ubuntu)
tempfile="$(mktemp)" && grep packer_${VERSION}_linux_amd64.zip packer_${VERSION}_SHA256SUMS > "$tempfile" && mv "$tempfile" packer_${VERSION}_SHA256SUMS
shasum -a 256 -c packer_${VERSION}_SHA256SUMS
unzip packer_${VERSION}_linux_amd64.zip
# NOTE: This will not work in Amazon Linux.
# Amazon Linux comes with an executable named "packer" on the PATH which is
# actually a program called "cracklib packer". If you are attempting to
# install Hashicorp Packer on Amazon Linux, you should consider changing
# the name of the other packer to "cracklib-packer", or change the Hashicorp
# packer executable name to be "hashicorp-packer" and refer to that within
# your scripts.
mv packer /usr/local/bin
