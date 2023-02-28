Root Password
=============

Description
-----------

The `root_password` role sets the password for the root user.


Variables
---------

This role **accepts** the following variables:

Variable             | Default | Description
---------------------|---------|------------
`root_password`      | &nbsp;  | Root password
`root_password_salt` | `''`    | Salt for SHA-512 hash


Usage
-----

Example playbook:

````yaml
- name: set password for root user
  hosts: all
  roles:
    - role: root_password
      vars:
        root_password: s3cret
        root_password_salt: changeme
````
