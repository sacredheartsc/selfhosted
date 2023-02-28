motd
====

Description
-----------

This role disables the default `cockpit` message from being displayed on login.

This role does not accept any variables.

Usage
-----

Example playbook:

````yaml
- name: remove motd spam
  hosts: all
  roles:
    - role: motd
````
