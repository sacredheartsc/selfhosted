FreeIPA Server
==============

Description
-----------

The `freeipa_server` role installs and configures the FreeIPA server. When
`ansible_fqdn == freeipa_master`, this role will configure the host as the
FreeIPA master. Otherwise, the host will be configured as a replica.

This role configures some custom schema changes to support Jabber IDs and
user/group email aliases. It also creates some default HBAC rules.


Variables
---------

This role **accepts** the following variables:

Variable                            | Default                        | Description
------------------------------------|--------------------------------|------------
`freeipa_domain`                    | `{{ ansible_domain }}`         | FreeIPA DNS domain
`freeipa_realm`                     | `{{ ansible_domain | upper }}` | FreeIPA realm name
`freeipa_workgroup`                 | `WORKGROUP`                    | SMB workgroup name
`freeipa_email_domain`              | `{{ email_domain }}`           | Default email domain for new users
`freeipa_dns_forwarders`            | `['8.8.8.8', '8.8.4.4']`       | Upstream DNS servers
`freeipa_dns_max_negative_cache`    | 5                              | Cache time for negative DNS responses (seconds)
`freeipa_nfs_homedirs`              | no                             | Add autofs map for `/home`
`freeipa_admin_password`            | &nbsp;                         | Password for `admin` account
`freeipa_ds_password`               | &nbsp;                         | Password for the Directory Server
`freeipa_idstart`                   | 100000                         | Minimum UID/GID
`freeipa_idmax`                     | 299999                         | Maximum UID/GID
`freeipa_maxpwdlife`                | 3650                           | Maximum password age (days)
`freeipa_minpwdlife`                | 1                              | Minumum password age (hours)
`freeipa_historylength`             | 0                              | Number of previous passwords to save
`freeipa_minclasses`                | 0                              | Minimum character classes in passwords
`freeipa_minlength`                 | 8                              | Minimum password length
`freeipa_maxfailcount`              | 6                              | Number of failed logins before account lockout
`freeipa_failinterval`              | 60                             | Duration to count login failures (seconds)
`freeipa_lockouttime`               | 600                            | Duration of account lockout (seconds)
`freeipa_admin_password_expiration` | 20310130235959                 | Password expiration time for `admin` account (YYYYMMDDHHMMSS)
`freeipa_default_login_shell`       | `/bin/bash`                    | Default user login shell


Usage
-----

Example playbook:

````yaml
- hosts: freeipa_master
  roles:
    - role: freeipa_server
      vars:
        freeipa_domain: ipa.example.com
        freeipa_realm: IPA.EXAMPLE.COM
        freeipa_workgroup: EXAMPLE
        freeipa_email_domain: example.com
        freeipa_admin_password: s3cret
        freeipa_ds_password: rea11y_s3cret

- hosts: freeipa_servers:!freeipa_master
  roles:
    - role: freeipa_server
      vars:
        freeipa_domain: ipa.example.com
        freeipa_realm: IPA.EXAMPLE.COM
        freeipa_admin_password: s3cret
````
