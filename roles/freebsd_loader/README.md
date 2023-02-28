FreeBSD Bootloader
==================

Description
-----------

The `freebsd_loader` role is used to set options in FreeBSD's
[loader.conf](https://man.freebsd.org/cgi/man.cgi?loader.conf(5)).

It is only used for configuring `loader.conf` options for OPNsense
firewalls.


Variables
---------

This role **accepts** the following variables:

Variable                         | Default   | Description
---------------------------------|-----------|------------
`freebsd_loader_config`          | {}        | Mapping of bootloader options


Usage
-----

Example playbook:

````yaml
- name: configure freebsd bootloader
  hosts: opnsense_firewalls
  roles:
    - role: freebsd_loader
      vars:
        freebsd_loader_config:
          'mrsas_load': 'YES'
          'hw.mfi.mrsas_enable': 1
          'kern.ipc.nmbclusters': 1000000
          'kern.ipc.nmbjumbop': 524288
````
