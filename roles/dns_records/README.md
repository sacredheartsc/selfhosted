DNS Records
===========

Description
-----------

The `dns_records` role adds A, PTR, and CNAME records for the host in FreeIPA.


Variables
---------

This role **accepts** the following variables:

Variable     | Default        | Description
------------------------------|------------
`dns_ip`     | `{{ ip }}`     | IP of the host
`dns_fqdn`   | `{{ fqdn }}`   | FQDN of the host
`dns_cnames` | `{{ cnames }}` | FQDN aliases of the host


Usage
-----

Example playbook:

````yaml
- name: add DNS records
  hosts: all
  roles:
    - dns_records
````
