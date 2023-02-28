Hastebin
========

Description
-----------

The `hastebin` role installs and configures [Hastebin](https://github.com/toptal/haste-server),
an open source pastebin.

This role configures the NodeJS application only; it does not configure a reverse
proxy.


Variables
---------

This role **accepts** the following variables:

Variable                  | Default  | Description
--------------------------|----------|------------
`hastebin_version`        | `master` | Git version to install
`hastebin_upload_cidrs`   | `[]`     | List of CIDRS from which to allow new pastes
`hastebin_port`           | 8080     | Local listening port
`hastebin_expire_days`    | 0        | Paste expiration time (days, 0 to disable)

This role **exports** the following variables:

Variable                 | Description
-------------------------|------------
`hastebin_apache_config` | Apache config block to configure a reverse proxy
`hastebin_archive_shell` | Shell command to create tarball of hastebin data

Usage
-----

Example playbook:

````yaml
- name: configure hastebin web application
  hosts: hastebin_servers
  roles:
    - role: hastebin
      hastebin_port: 8080
      hastebin_upload_cidrs:
        - 10.10.10.0/24
      hastebin_expire_days: 30

    - role: apache_vhost
      apache_server_name: hastebin.example.com
      apache_server_aliases: []
      apache_letsencrypt: yes
      apache_config: '{{ hastebin_apache_config }}'
````
