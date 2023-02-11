Development Environment
=======================

Description
-----------

The `dev_environment` role installs various packages useful for a Linux
development workstation.

This role takes no variables. The list of installed packages can be found
in the [vars file](vars/main.yml).


Usage
-----

Example playbook:

````yaml
- name: install development packages
  hosts: linux_desktops 
  roles:
    - role: dev_environment
````
