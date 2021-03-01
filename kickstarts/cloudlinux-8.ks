# CloudLinux OS 8 kickstart file for base Docker image

install
url --url https://repo.almalinux.org/almalinux/8/BaseOS/x86_64/kickstart/
repo --name BaseOS --baseurl https://repo.cloudlinux.com/cloudlinux/8/BaseOS/x86_64/os/
repo --name AppStream --baseurl https://repo.cloudlinux.com/cloudlinux/8/AppStream/x86_64/os/

lang en_US.UTF-8
keyboard us
timezone --nontp --utc UTC

network --activate --bootproto=dhcp --device=link --onboot=on
firewall --disabled
selinux --disabled

bootloader --disable
zerombr
clearpart --all --initlabel
autopart --fstype=ext4 --type=plain --nohome --noboot --noswap

rootpw --iscrypted --lock almalinux

shutdown

%packages --ignoremissing --excludedocs --instLangs=en_US.UTF-8 --nocore
almalinux-release
bash
binutils
coreutils-single
dnf
glibc-minimal-langpack
hostname
iputils
less
rootfiles
tar
vim-minimal
# TODO: do we really need yum additionally to dnf?
yum

-brotli
-firewalld
-gettext*
-gnupg2-smime
-grub\*
-iptables
-kernel
-os-prober
-pinentry
-shared-mime-info
-trousers
-xkeyboard-config
# CloudLinux OS specific
-kmod-lve
-lve-utils
-lvemanager
%end


%post --erroronfail --log=/root/anaconda-post.log
# generate build time file for compatibility with CentOS
/bin/date +%Y%m%d_%H%M > /etc/BUILDTIME

# set DNF infra variable to container for compatibility with CentOS
echo 'container' > /etc/dnf/vars/infra

# import CloudLinux OS PGP key
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CloudLinux

# disable CloudLinux OS gradual rollout repositories
sed -i 's/enabled\ *=\ *1/enabled=0/g' /etc/yum.repos.d/cloudlinux-rollout.repo

# install only en_US.UTF-8 locale files, see
# https://fedoraproject.org/wiki/Changes/Glibc_locale_subpackaging for details
echo '%_install_langs en_US.UTF-8' > /etc/rpm/macros.image-language-conf

# force each container to have a unique machine-id
> /etc/machine-id

# create tmp directories because there is no tmpfs support in Docker
umount /run
systemd-tmpfiles --create --boot

# disable login prompt and mounts
systemctl mask console-getty.service \
               dev-hugepages.mount \
               getty.target \
               systemd-logind.service \
               sys-fs-fuse-connections.mount \
               systemd-remount-fs.service

# remove unnecessary files
rm -f /var/lib/dnf/history.* \
      /run/nologin
rm -fr /var/log/* \
       /tmp/* /tmp/.* || true
%end
