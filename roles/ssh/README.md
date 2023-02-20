SSH
===

Description
-----------

The `ssh` role configures SSH clients to use GSSAPI authentication for hosts
within the local FreeIPA domain.


Variables
---------

This role **accepts** the following variables:

Variable                | Default                    | Description
------------------------|----------------------------|------------
`ssh_canonical_domains` | `['{{ ansible_domain }}']` | Host domains to canonicalize for Kerberos/GSSAPI 


Usage
-----

Example playbook:

````yaml
- name: configure kerberized ssh
  hosts: all
  roles:
    - role: ssh
      vars:
        ssh_canonical_domains:
          - ipa.example.com
````
