Chrony
======

Description
-----------

The `chrony` role configures the [chrony](https://chrony.tuxfamily.org/) NTP
daemon.

Variables
---------

This role **accepts** the following variables:

Variable             | Default                  | Description
---------------------|--------------------------|------------
`chrony_ntp_servers` | `{{ vlan.ntp_servers }}` | List of upstream NTP servers

Usage
-----

Example playbook:

````yaml
- name: configure NTP
  hosts: all
  roles:
    - role: chrony
      vars:
        chrony_ntp_servers:
          - 0.north-america.pool.ntp.org
          - 1.north-america.pool.ntp.org
          - 2.north-america.pool.ntp.org
          - 3.north-america.pool.ntp.org
````
