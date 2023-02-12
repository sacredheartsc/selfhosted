firewalld
=========

Description
-----------

The `firewalld` role enables the local firewall and disables the built-in
`cockpit` allow rule (we don't use it).

This role does not use any variables.


Usage
-----

Example playbook:

````yaml
- hosts: all
  roles:
    - role: firewalld
````
