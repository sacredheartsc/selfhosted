PXE Server
==========

Description
-----------

The `pxe_server` role generates TFTP boot files for PXE booting Rocky Linux. It
downloads bootable images and generates kickstart files.

It does not actually configure the TFTP server itself; I use the OPNsense
`tftp` plugin to serve these files. You will also need an HTTP server to serve
the kernel and initrd files (you _can_ serve these over TFTP, but it's very
slow).

Grub
----

You will need to build grub binaries and upload them to `$tftpboot/grub`. You
can generate them on an existing Rocky Linux host.

First, install the required packages:

````bash
dnf install grub2 grub2-pc grub2-efi grub2-pc-modules grub2-efi-x64-modules grub2-efi-aa64-modules
````

Then, generate the images:

````bash
  # location of the grub.cfg files within the tftp root
  PREFIX=/grub
  COMMON_MODULES="normal linux echo http tftp reboot configfile"

  # The last arguments are the modules to "statically link" into the grub image...
  # the alternative is to put like 50 .mod files in the tftpboot directory.
  grub2-mkimage --format=x86_64-efi  --output=bootx64.efi  -p $PREFIX $COMMON_MODULES efinet bsd
  grub2-mkimage --format=arm64-efi   --output=bootaa64.efi -p $PREFIX $COMMON_MODULES efinet
  grub2-mkimage --format=i386-pc-pxe --output=booti386     -p $PREFIX $COMMON_MODULES pxe bsd
````

Variables
---------

This role **accepts** the following variables:

Variable                 | Default                      | Description
-------------------------|------------------------------|------------
`pxe_root`               | `/tftpboot`                  | Path to store boot files
`pxe_http_port`          | 80                           | Port of HTTP server
`pxe_grub_prefix`        | `grub`                       | Subdirectory for grub files
`pxe_ks_locale`          | `en_US.UTF-8`                | Kickstart locale
`pxe_ks_authorized_keys` | `{{ root_authorized_keys }}` | Kickstart `authorized_keys` for root user
`pxe_ks_timezone`        | `{{ timezone }}`             | Kickstart timezone
`pxe_ks_password`        | `{{ root_password }}`        | Kickstart root password
`pxe_ks_password_salt`   | `{{ root_password_salt }}`   | Kickstart root password salt
