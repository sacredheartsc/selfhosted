Local Homedirs
==============

Description
-----------

The `local_homedirs` provisions per-user space on the local disk to accomdate
applications that perform poorly with NFS home directories.

Basically, this role adds some PAM modules and login scripts that cause
various applications to write to `/usr/local/home/$USER`, rather than
`/home/$USER`.

This role does not accept any variables.

Usage
-----

Example playbook:

````yaml
- name: set up additional home directories on the local disk
  hosts: linux_desktops
  roles:
    - role: local_homedirs
````
