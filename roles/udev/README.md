udev
=====

Description
-----------

The `udev` role configures specified udev rules and generates a powersave
blacklist based on vendor and device IDs.


Variables
---------

This role **accepts** the following variables:

Variable                       | Default | Description
-------------------------------|---------|------------
`udev_rules`                   | `[]`    | List of udev rules (see [format](#udev_rules) below)
`udev_pci_powersave_blacklist` | `[]`    | List of PCI devices with powersaving disabled (`vendorid:productid`)

### udev\_rules

The `udev_rules` variable is used to add udev rulesets. It should contain a
list of dictionaries of the following format:

Key    | Default   | Description
-------|-----------|------------
`name` | &nbsp;    | Name of rule under `/etc/udev/rules.d`
`rule` | &nbsp;    | Rule content

Usage
-----

Example playbook:

````yaml
- name: disable powersaving for NIC
  hosts: linux_desktops
  roles:
    - role: udev
      vars:
        udev_pci_powersave_blacklist:
          - 8086:43e0
````
