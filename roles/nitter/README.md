Nitter
======

Description
-----------

The `gathio` role installs and configures [Nitter](https://github.com/zedeus/nitter),
an open source Twitter frontend. It also installs a script to update Nitter
periodically.

This role configures the application only; it does not configure a reverse proxy.


Variables
---------

This role **accepts** the following variables:

Variable                       | Default              | Description
-------------------------------|----------------------|------------
`nitter_version`               | `master`             | Git version to install
`nitter_server_name`           | `{{ ansible_fqdn }}` | Canonical HTTP hostname
`nitter_port`                  | 8080                 | Local listening port
`nitter_update_on_calendar`    | `weekly`             | Systemd [calendar interval](https://www.freedesktop.org/software/systemd/man/systemd.time.html#Calendar%20Events) for updating Nitter
`nitter_hmac_key`              | &nbsp;               | Random key for cryptographic signing of video URLs
`nitter_max_connections`       | 100                  | Maximum number of HTTP connections
`nitter_token_count`           | 10                   | Minimum number of API tokens
`nitter_cache_list_minutes`    | 240                  | List cache duration (minutes)
`nitter_cache_rss_minutes`     | 10                   | RSS cache duration (minutes)
`nitter_redis_port`            | 6379                 | Port for local redis instance
`nitter_redis_connections`     | 20                   | Redis connection pool size
`nitter_redis_max_connections` | 30                   | Maximum number of open redis connections

This role **exports** the following variables:

Variable               | Description
-----------------------|------------
`nitter_apache_config` | Apache config block to configure a reverse proxy

Usage
-----

Example playbook:

````yaml
- name: configure nitter web application
  hosts: nitter_servers
  roles:
    - role: nitter
      vars:
        nitter_server_name: nitter.example.com
        nitter_hmac_key: s3cret

    - role: apache_vhost
      apache_server_name: '{{ nitter_server_name }}'
      apache_server_aliases: []
      apache_config: '{{ nitter_apache_config }}'
````
