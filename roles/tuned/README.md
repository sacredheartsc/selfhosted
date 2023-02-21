TuneD
=====

Description
-----------

The `tuned` role sets the host's [TuneD](https://tuned-project.org/) performance
profile.

Variables
---------

This role **accepts** the following variables:

Variable        | Default   | Description
----------------|-----------|------------
`tuned_profile` | `balanced | TuneD profile name


Usage
-----

Example playbook:

````yaml
- name: set tuned profile
  hosts: proxmox_instanced
  roles:
    - role: tuned
      vars:
        tuned_profile: virtual-guest
````
