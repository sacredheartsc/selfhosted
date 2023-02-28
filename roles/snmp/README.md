SNMP
====

Description
-----------

The `snmp` role installs [net-snmp](http://www.net-snmp.org/) and adds
SNMPv3 user accounts.

Variables
---------

This role **accepts** the following variables:

Variable           | Default                                         | Description
-------------------|-------------------------------------------------|------------
`snmp_location`    | `unknown`                                       | SNMP location string
`snmp_contact`     | `root@{{ email_domain }}`                       | SNMP email contact
`snmp_force_users` | no                                              | Re-create SNMPv3 users even if they already exist
`snmp_v3_users`    | nagios user (see [defaults](defaults/main.yml)) | SNMPv3 user accounts (see [format](#snmp_v3_users) below)

### snmp\_v3\_users

The `snmp_v3_users` variable specifies the SNMPv3 users to create. It should
contain a list of dictionaries of the following format:

Key         | Default    | Description
------------|------------|------------
`name`      | &nbsp;     | SNMPv3 username
`auth_pass` | &nbsp;     | SNMPv3 authentication password
`priv_pass` | &nbsp;     | SNMPv3 privacy password

Usage
-----

Example playbook:

````yaml
- name: configure SNMP client
  hosts: all
  roles:
    - role: snmp
      vars:
        snmp_location: my datacenter
        snmp_contact: sysadmins@example.com
        snmp_v3_users:
          - name: nagios
            auth_pass: s3cret
            priv_pass: hunter2
````
