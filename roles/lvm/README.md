LVM
===

Description
-----------

The `lvm` role configures the Logical Volume Manager.

Currently this role is only used to disable the `use_devicesfile` option in
`lvm.conf`.  This was enabled by default starting in RHEL 9.0, and rendered
some of my systems unbootable after the 9.2 upgrade.


Variables
---------

This role **accepts** the following variables:

Variable              | Default | Description
----------------------|---------|------------
`lvm_use_devicesfile` | `no`    | Enables use of the LVM [devices file](https://man7.org/linux/man-pages/man8/lvmdevices.8.html)


Usage
-----

Example playbook:

````yaml
- name: configure lvm
  hosts: all
  roles:
    - role: lvm
      vars:
        lvm_use_devicesfile: no
````
