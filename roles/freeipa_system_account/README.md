FreeIPA System Account
======================

Description
-----------

The `freeipa_system_account` role creates a FreeIPA [system account](https://www.freeipa.org/page/HowTo/LDAP#System_Accounts)
with the provided username and password.

System accounts are limited to LDAP queries only; they have no POSIX attributes,
cannot log into any systems, etc.


Variables
---------

This role **accepts** the following variables:

Variable                  | Default | Description
--------------------------|---------|------------
`system_account_username` | &nbsp;  | System account username
`system_account_password` | &nbsp;  | System account password


Usage
-----

Example tasks:

````yaml
- name: create system account for ldap binds
  include_role:
    name: freeipa_system_account
  vars:
    system_account_username: apache
    system_account_password: s3cret
````
