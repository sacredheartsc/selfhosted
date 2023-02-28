Grub
====

Description
-----------

The `grub` role sets the Grub prompt timeout and the default Linux kernel
command line.

Variables
---------

This role **accepts** the following variables:

Variable       | Default | Description
---------------|---------|------------
`grub_timeout` | 1       | Grub menu timeout (seconds)
`grub_cmdline` | &nbsp;  | Kernel command line

Usage
-----

Example playbook:

````yaml
- name: configure grub bootloader
  hosts: proxmox_instances
  roles:
    - role: grub
      vars:
        grub_timeout: 1
        grub_cmdline: console=ttyS0,115200n8 no_timer_check net.ifnames=0
````
