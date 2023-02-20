sabre/dav
=========

Description
-----------

The `sabredav` role installs and configures the [sabre/dav](https://sabre.io/dav/)
CalDAV/CardDAV server. Authentication and group memberships are provided by
FreeIPA using the [sabredav-freeipa(https://github.com/sacredheartsc/sabredav-freeipa)
project.

This role configures the PHP application only; it does not configure the webserver.


Variables
---------

This role **accepts** the following variables:

Variable                    | Default                               | Description
----------------------------|---------------------------------------|------------
`sabredav_version`          | `master`                              | Git version to install
`sabredav_user`             | `s-sabredav`                          | FreeIPA user for sabredav (will be created)
`sabredav_db_name`          | `sabredav`                            | PostgreSQL database name (will be created)
`sabredav_db_host`          | `{{ postgresql_host }}`               | PostgreSQL host
`sabredav_imip_from`        | `calendar-noreply@{{ email_domain }}` | Email `From:` address for iMIP invites
`sabredav_access_group`     | `role-dav-access`                     | FreeIPA group for sabredav
`sabredav_kerberized_cidrs` | `{{ kerberized_cidrs }}`              | Client CIDRs that use GSSAPI authentication

### Exports

This role **exports** the following variables:

Variable                     | Description
---------------------------|------------
`sabredav_home`            | Path to MediaWiki installation
`sabredav_php_environment` | Dictionary of required environment variables for PHP
`sabredav_php_flags`       | Dictionary of required flags for PHP
`sabredav_archive_shell`   | Shell command to generate backup tarball
`sabredav_apache_config`   | Apache config block for sabre/dav


Usage
-----

Example playbook:

````yaml
- name: configure sabredav
  hosts: dav_servers
  roles:
    - role: sabredav

    - role: apache_vhost
      apache_default_vhost: yes
      apache_document_root: '{{ sabredav_home }}'
      apache_config: '{{ sabredav_apache_config }}'

    - role: php
      php_fpm_environment: '{{ sabredav_php_environment }}'
      php_fpm_admin_flags: '{{ sabredav_php_flags }}'
````
