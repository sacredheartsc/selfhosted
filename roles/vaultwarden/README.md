Vaultwarden
===========

Description
-----------

The `vaultwarden` role installs [Vaultwarden](https://github.com/dani-garcia/vaultwarden),
an unofficial Bitwarden-compatible server written in Rust.

This role configures the Rust application only; it does not set up a reverse
proxy.

Variables
---------

This role **accepts** the following variables:

Variable                               | Default                                | Description
---------------------------------------|----------------------------------------|------------
`vaultwarden_version`                  | see [defaults](defaults/vars.yml)      | Git version of Vaultwarden to install
`vaultwarden_web_version`              | see [defaults](defaults/vars.yml)      | Git version of web vault to install
`vaultwarden_port`                     | 8008                                   | Local listening port
`vaultwarden_websocket_port`           | 8009                                   | Local websocket port
`vaultwarden_server_name`              | `{{ ansible_fqdn }}`                   | Canonical HTTP hostname
`vaultwarden_user`                     | `s-vaultwarden`                        | FreeIPA user (will be created)
`vaultwarden_db_name`                  |  `vaultwarden`                         | PostgreSQL database (will be created)
`vaultwarden_db_host`                  | `{{ postgresql_host }}`                | PostgreSQL host
`vaultwarden_verify_signups`           | yes                                    | Confirm email address of new users
`vaultwarden_signup_domain_whitelist`  | `['{{ email_domain }}']`               | Allowed email domains (empty list to allow all)
`vaultwarden_invitations_allowed`      | no                                     | Allow admins to invite users
`vaultwarden_user_attachment_limit_kb` | 1048576                                | Per-user attachment size limit (KB)
`vaultwarden_admin_group`              | `role-bitwarden-admin`                 | FreeIPA group for Vaultwarden administrators (will be created)
`vaultwarden_smtp_host`                | `{{ mail_host }}`                      | SMTP host
`vaultwarden_smtp_from`                | `bitwarden-noreply@{{ email_domain }}` | Email `From:` address
`vaultwarden_smtp_from_name`           | `Bitwarden`                            | Email `From:` name

This role **exports** the following variables:

Variable                    | Description
----------------------------|------------
`vaultwarden_apache_config` | Apache config block for reverse proxy

Usage
-----

Example playbook:

````yaml
- name: configure vaultwarden
  hosts: vaultwarden_servers
  roles:
    - role: vaultwarden
      vars:
        vaultwarden_db_host: postgres.ipa.example.com
        vaultwarden_verify_signups: yes
        vaultwarden_signup_domain_whitelist: []
        vaultwarden_admin_group: vaultwarden-admins

    - role: apache
      vars:
        apache_default_vhost: yes
        apache_canonical_hostname: '{{ vaultwarden_server_name }}'
        apache_config: '{{ vaultwarden_apache_config }}'
````
