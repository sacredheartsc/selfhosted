Polkit
======

Description
-----------

The `polkit` role simply adds a [polkit rule](https://www.freedesktop.org/software/polkit/docs/latest/polkit.8.html)
to allow a given group to perform privleged operations.

The only time `polkit` escalation must be used (rather than `sudo`) seems to be
when performing privileged operations from the GNOME interface.


Variables
---------

This role **accepts** the following variables:

Variable                         | Default   | Description
---------------------------------|-----------|------------
`polkit_admin_group`             | `wheel`   | Group name for system administrators


Usage
-----

Example playbook:

````yaml
- name: configure polkit
  hosts: all
  roles:
    - role: polkit
      vars:
        polkit_admin_group: sysadmins
````
