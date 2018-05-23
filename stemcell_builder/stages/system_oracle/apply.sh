#!/usr/bin/env bash

set -e

base_dir=$(readlink -nf $(dirname $0)/../..)
source $base_dir/lib/prelude_apply.bash

# Remove V1 grub
pkg_mgr purge grub grub-pc grub-common

# Install v2 grub and efi
pkg_mgr install efibootmgr dmidecode ssh-import-id open-iscsi iptables-persistent \
  grub2-common grub-efi-amd64-bin lsscsi

# https://bugs.launchpad.net/ubuntu/+source/grub2/+bug/1692235
pkg_mgr install grub-pc || true

# Copy in Oracle specific assets
yes | cp -rf ${dir}/assets/etc/* ${chroot}/etc/

# Workaround until https://github.com/cloudfoundry/bosh-agent/pull/147
# for bosh-agent is merged upstream and available for inclusion
# in the stemcell.
run_in_chroot $chroot "mkdir -p /var/vcap/data"
run_in_chroot $chroot "chmod 755 /var/vcap/data"
