Nagios Client
=============

Description
-----------

The `nagios_client` role creates the `nagios` user and installs Nagios plugins.


Variables
---------

This role **accepts** the following variables:

Variable                         | Default   | Description
---------------------------------|-----------|------------
`nagios_ssh_pubkey`              | &nbsp;    | SSH public key for `nagios` user


Usage
-----

Example playbook:

````yaml
- name: configure host as a nagios client
  hosts: all
  roles:
    - role: nagios_client
      vars:
        nagios_ssh_pubkey: |
          ssh-ed25519 AAAA...
````
