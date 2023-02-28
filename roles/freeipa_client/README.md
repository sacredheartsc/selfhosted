FreeIPA Client
==============

Description
-----------

The `freeipa_client` role installs FreeIPA packages, joins the host to the
local FreeIPA domain, and optionally configures `autofs`.


Variables
---------

This role **accepts** the following variables:

Variable         | Default | Description
-----------------|---------|------------
`freeipa_autofs` | yes     | Configure FreeIPA automount client


Usage
-----

Example playbook:

````yaml
- name: join host to freeipa domain
  hosts: all
  roles:
    - role: freeipa_client
      vars:
        freeipa_autofs: yes
````
