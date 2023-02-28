Tiny Tiny RSS
=============

Description
-----------

The `ttrss` role installs and configures the [Tiny Tiny RSS](https://tt-rss.org/)
feed aggregator.

The [ttrss-auth-ldap](https://github.com/sacredheartsc/ttrss-freeipa) is used to
authenticate users against the local FreeIPA domain.

This role configures the PHP application only; it does not configure the webserver.


Variables
---------

This role **accepts** the following variables:

Variable                       | Default                            | Description
-------------------------------|------------------------------------|------------
`ttrss_version`                | `HEAD`                             | Git version of TT-RSS to install
`ttrss_freeipa_plugin_version` | `HEAD`                             | Git version of FreeIPA plugin to install
`ttrss_update_on_calendar`     | `weekly`                           | Systemd [calendar interval](https://www.freedesktop.org/software/systemd/man/systemd.time.html#Calendar%20Events) for updating TT-RSS
`ttrss_server_name`            | `{{ ansible_fqdn }}`               | Canonical HTTP hostname
`ttrss_db_host`                | `{{ postgresql_host }}`            | PostgreSQL host
`ttrss_user`                   | `s-ttrss`                          | PostgreSQL user (will be created)
`ttrss_db_name`                | `ttrss`                            | PostgreSQL database (will be created)
`ttrss_session_lifetime_sec`   | 604800                             | Login session lifetime (seconds)
`ttrss_email_from_name`        | `Tiny Tiny RSS`                    | Email `From:` name
`ttrss_email_from_address`     | `ttrss-noreply@{{ email_domain }}` | Email `From:` address
`ttrss_access_group`           | `role-ttrss-access`                | FreeIPA group for TT-RSS users (will be created)
`ttrss_admin_group`            | `role-ttrss-admin`                 | FreeIPA group for TT-RSS administrators (will be created)


### Exports

This role **exports** the following variables:

Variable                | Description
------------------------|------------
`ttrss_php_environment` | Dictionary of required environment variables for PHP
`ttrss_apache_config`   | Apache config block for TT-RSS
`ttrss_home`            | TT-RSS webroot


Usage
-----

Example playbook:

````yaml
- name: configure tinytinyrss web application
  hosts: ttrss_servers
  roles:
    - role: ttrss
      vars:
        ttrss_server_name: ttrss.ipa.example.com
        ttrss_db_host: postgres.ipa.example.com
        ttrss_access_group: ttrss-users
        ttrss_admin_group: ttrss-admins


    - role: php
      vars:
        php_fpm_environment: '{{ ttrss_php_environment }}'

    - role: apache_vhost
      vars:
        apache_default_vhost: yes
        apache_canonical_hostname: '{{ ttrss_server_name }}'
        apache_document_root: '{{ ttrss_home }}'
        apache_config: '{{ ttrss_apache_config }}'
````
