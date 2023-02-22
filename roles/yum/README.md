Yum
===

Description
-----------

The `yum` role is used to add a local RPM repository as a package source.
Repository names are configured in the [vars file](vars/main.yml).

It should be used in conjunction with local Yum server built using the
[yum\_mirror](../yum_mirror/) role.

There is one special case hardcoded: enabling the `epel` repository will always
enable the `rocky-powertools` or `rocky-crb` repo as well.

Variables
---------

This role **accepts** the following variables:

Variable                         | Default   | Description
---------------------------------|-----------|------------
`yum_host`                       | &nbsp;    | Hostname of the local Yum server
`yum_add_repositories`           | &nbsp;    | List of repository names to enable

Usage
-----

Example playbook:

````yaml
- name: enable extra yum repositories
  hosts: linux_desktops
  roles:
    - role: yum
      yum_repositories:
        - epel
        - rpmfusion-free
        - rpmfusion-free-tainted
        - rpmfusion-nonfree
        - rpmfusion-nonfree-tainted
````
