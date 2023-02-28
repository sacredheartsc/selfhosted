Gathio
======

Description
-----------

The `gathio` role installs and configures [Gathio](https://github.com/lowercasename/gathio),
a web application for managing public events.

This role configures the NodeJS application only; it does not configure a reverse
proxy.


Variables
---------

This role **accepts** the following variables:

Variable              | Default                             | Description
----------------------|-------------------------------------|------------
`gathio_version`      | `master`                            | Git version to install
`gathio_port`         | 8080                                | Local listening port
`gathio_from_address` | `events-noreply@{{ email_domain }}` | Email `From:` address for event notifications
`gathio_server_name`  | `{{ ansible_fqdn }}`                | Canonical HTTP hostname
`gathio_site_name`    | `gathio`                            | Site name used for page titles

This role **exports** the following variables:

Variable               | Description
-----------------------|------------
`gathio_apache_config` | Apache config block to configure a reverse proxy

Usage
-----

Example playbook:

````yaml
- name: configure gathio web application
  hosts: gathio_servers
  roles:
    - role: gathio
      gathio_port: 8080
      gathio_from_address: events-noreply@example.com
      gathio_site_name: Example Org Events
      gathio_server_name: events.example.com

    - role: apache_vhost
      apache_server_name: '{{ gathio_server_name }}'
      apache_server_aliases: []
      apache_letsencrypt: yes
      apache_config: '{{ gathio_apache_config }}'
````
