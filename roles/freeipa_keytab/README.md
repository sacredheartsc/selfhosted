FreeIPA Keytab
==============

Description
-----------

The `freeipa_keytab` role retrieves an account's keytab from FreeIPA.

Whenever a new keytab is fetched, the account's password is reset.


Variables
---------

This role **accepts** the following variables:

Variable           | Default            | Description
-------------------|--------------------|------------
`keytab_principal` | &nbsp;             | FreeIPA account principal (without realm component)
`keytab_path`      | `/etc/krb5.keytab` | Path to store keytab
`keytab_owner`     | `root`             | Owner of keytab file
`keytab_group`     | `root`             | Group owner of keytab file
`keytab_mode`      | 0600               | Permissions of keytab file


Usage
-----

Example tasks:

````yaml
- name: create HTTP service principal
  ipaservice:
    ipaadmin_principal: '{{ ipa_user }}'
    ipaadmin_password: '{{ ipa_pass }}'
    name: 'HTTP/{{ ansible_fqdn }}'
    state: present

- name: retrieve HTTP keytab
  include_role:
    name: freeipa_keytab
  vars:
    keytab_principal: 'HTTP/{{ ansible_fqdn }}'
    keytab_path: /etc/httpd/apache.keytab
````
