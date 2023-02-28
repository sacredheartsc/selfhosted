PostgreSQL Server
=================

Description
-----------

The `postgresql_server` role installs and configures the PostgreSQL database,
and configures the server for client GSSAPI authentication.

Variables
---------

This role **accepts** the following variables:

Variable                         | Default          | Description
---------------------------------|------------------|------------
`postgresql_timezone`            | `{{ timezone }}` | Database timezone
`postgresql_max_connections`     | 100              | Maximum number of concurrent connections
`postgresql_shared_buffers_mb`   | 25% of host RAM  | Shared buffer size (MB)
`postgresql_password_users`      | `[]`             | List of users that don't support GSSAPI authentication

Usage
-----

Example playbook:

````yaml
- name: configure postgresql database
  hosts: postgresql_servers
  roles:
    - role: postgresql
      vars:
        postgresql_password_users:
          - invidious
          - mydbuser
````
