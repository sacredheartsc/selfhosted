Unifi
=====

Description
-----------

The `unifi` role installs the [UniFi](https://www.ui.com/wi-fi) controller, a
web application used to manage Ubiquiti's UniFi line of wireless access points.

This role currently requires Rocky Linux 8 due to unavailability of packages
in EPEL 9.


Variables
---------

This role does not accept any variables.

This role **exports** the following variables:

Variable              | Description
----------------------|------------
`unifi_archive_shell` | Shell command to backup UniFi configuration data

Usage
-----

Example playbook:

````yaml
- name: configure unifi controller
  hosts: unifi_controllers
  roles:
    - role: unifi
````
