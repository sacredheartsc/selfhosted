CUPS Client
===========

Description
-----------

The `cups_client` role configures a Linux host to print to a central CUPS server.


Variables
---------

This role **accepts** the following variables:

Variable    | Default | Description
------------|---------|------------
`cups_host` | &nbsp;  | Hostname of CUPS server


Usage
-----

Example playbook:

````yaml
- name: configure CUPS client
  hosts: linux_desktops 
  roles:
    - role: cups_client
      vars:
        cups_host: cups.example.com
````
