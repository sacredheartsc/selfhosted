Packages
========

Description
-----------

The `packages` role installs a given set of packages.

Variables
---------

This role **accepts** the following variables:

Variable           | Default  | Description
-------------------|----------|------------
`packages_install` | `[]`     | List of packages to install

Usage
-----

Example playbook:

````yaml
- hosts: all
  roles:
    - role: packages
      vars:
        packages_install:
          - tmux
          - less
          - man
````
