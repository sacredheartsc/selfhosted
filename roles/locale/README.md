Locale
======

Description
-----------

The `locale` role sets the default system locale.


Variables
---------

This role **accepts** the following variables:

Variable | Default       | Description
---------|---------------|------------
`locale` | `en_US.UTF-8` | Locale name


Usage
-----

Example playbook:

````yaml
- name: set the system locale
  hosts: all
  roles:
    - role: locale
      vars:
        locale: en_US.UTF-8
````
