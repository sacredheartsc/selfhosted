Root Authorized Keys
====================

Description
-----------

The `root_authorized_keys` role adds SSH public keys to the root user's
`authorized_keys` file.


Variables
---------

This role **accepts** the following variables:

Variable               | Default | Description
-----------------------|---------|------------
`root_authorized_keys` | `[]`    | List of SSH pubkeys


Usage
-----

Example playbook:

````yaml
- name: set authorized_keys for root user
  hosts: all
  roles:
    - role: root_authorized_keys
      vars:
        root_authorized_keys:
          - ssh-ed25519 AAAA...
          - ssh-ed25519 AAAA...
````
