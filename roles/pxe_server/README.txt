To generate the grub binaries:
------------------------------

Install the required packages:

  dnf install grub2 grub2-pc grub2-efi grub2-pc-modules grub2-efi-x64-modules grub2-efi-aa64-modules

Generate the images:

  # location of the grub.cfg files within the tftp root
  PREFIX=/grub
  COMMON_MODULES="normal linux echo http tftp reboot configfile"

  # Last arguments are the modules to "statically link" into the grub image.
  # I'd rather not maintain a bunch of .mod files within the tftp directory.
  grub2-mkimage --format=x86_64-efi  --output=bootx64.efi  -p $PREFIX $COMMON_MODULES efinet bsd
  grub2-mkimage --format=arm64-efi   --output=bootaa64.efi -p $PREFIX $COMMON_MODULES efinet
  grub2-mkimage --format=i386-pc-pxe --output=booti386     -p $PREFIX $COMMON_MODULES pxe bsd
