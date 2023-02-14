Hostname
========

Description
-----------

The `hostname` role sets the local hostname and generates `/etc/hosts`.

Variables
---------

This role **accepts** the following variables:

Variable         | Default                                 | Description
-----------------|-----------------------------------------|------------
`hostname_fqdn`  | `{{ inventory_hostname }}.{{ domain }}` | Fully qualified domain name
`hostname_short` | `{{ inventory_hostname }}`              | Short hostname
`hostname_ip`    | `{{ ip }}`                              | IPv4 address

Usage
-----

Example playbook:

````yaml
- name: set hostname
  hosts: all
  roles:
    - hostname
````
