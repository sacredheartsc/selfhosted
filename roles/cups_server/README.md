CUPS Server
===========

Description
-----------

The `cups_server` role installs and configures the CUPS print server.


Variables
---------

This role **accepts** the following variables:

Variable              | Default                   | Description
----------------------|---------------------------|------------
`cups_server_aliases` | `{{ cnames }}`            | Aliases used for HTTP header validation
`cups_server_admin`   | `root@{{ email_domain }}` | Email address of the server administrator
`cups_admin_group`    | `role-cups-admin`         | FreeIPA group for CUPS administrators (will be created)


Usage
-----

Example playbook:

````yaml
- name: configure CUPS servers
  hosts: cups_servers 
  roles:
    - role: cups_server
      vars:
        cups_server_admin: printer-admin@example.com
        cups_admin_group: print-admins
````
