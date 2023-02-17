Photostructure
==============

Description
-----------

The `photostructure` role installs [Photostructure](https://photostructure.com/),
a web application for managing your photo library.

Note that this is a proprietary application. You'll be prompted for a license key
after installation.

Photostructure does not currently support authentication or multiple users.
This role exports a variable containing an Apache configuration block that you
can use to do user authorization from the reverse proxy.

This role configures the NodeJS application only; it does not configure Apache.


Variables
---------

This role **accepts** the following variables:

Variable                                 | Default                  | Description
-----------------------------------------|--------------------------|------------
`photostructure_port`                    | 8080                     | Local listening port
`photostructure_scan_interval_hours`     | 24                       | Library scan interval (hours)
`photostructure_max_cpu_percent`         | 95                       | CPU usage target (%)
`photostructure_log_level`               | `warn`                   | Log level (`info`, `warn`, `crit`, etc)
`photostructure_backup_interval_minutes` | 30                       | Backup interval for SQLite database (minutes)
`photostructure_version`                 | `alpha`                  | Git version to install
`photostructure_user`                    | `s-photostructure`       | FreeIPA user for Photostructure application
`photostructure_file_access_group`       | `role-photo-admin`       | FreeIPA group used to access photo files
`photostructure_kerberized_cidrs`        | `{{ kerberized_cidrs }}` | List of client CIDRs supporting GSSAPI authentication

This role **exports** the following variables:

Variable                       | Description
-------------------------------|------------
`photostructure_apache_config` | Apache config block for reverse proxy
`photostructure_archive_shell` | Shell command to create backup tarball

Usage
-----

Example playbook:

````yaml
- hosts: photostructure_servers
  roles:
    - role: photostructure

    - role: apache_vhost
      apache_default_vhost: yes
      apache_config: '{{ photostructure_apache_config }}'
````
