Mastodon
========

Description
-----------

The `mastodon` role installs and configures the [Mastodon](https://github.com/mastodon/mastodon)
social network server. It allows you to interact with the [Fediverse](https://joinmastodon.org/).

Users authenticate against the local FreeIPA domain. The Mastodon username
for each user is taken from the `mastodonUsername` attribute of the FreeIPA
User object.

If your Mastodon domain differs from the public hostname of your server
(e.g. your IDs have the format `@user@example.com`, but Mastodon runs on
`mastodon.example.com`), then you will need to configure `.well-known` delegation
in order to federate with other instances. See the [sample webserver playbook](../../playbooks/webserver_public_example.yml)
for an example of how to do this.

Note that unlike most other roles in this project, Mastodon does not support
kerberized PostgreSQL authentication. Therefore, you must explicitly set a
database password and ensure the `postgresql_password_users` array contains
the `mastodon_db_user`.


Variables
---------

This role **accepts** the following variables:

Variable                       | Default                               | Description
-------------------------------|---------------------------------------|------------
`mastodon_version`             | see [defaults](defaults/main.yml)     | [mastodon](https://github.com/mastodon/mastodon) version to install
`mastodon_domain`              | `{{ email_domain }}`                  | Mastodon domain served by this server
`mastodon_web_domain`          | `{{ ansible_fqdn }}`                  | Public hostname for the web UI
`mastodon_db_user`             | `s-mastodon`                          | PostgreSQL username
`mastodon_db_password`         | &nbsp;                                | PostgreSQL password
`mastodon_db_host`             | `{{ postgresql_host }}`               | PostgreSQL host
`mastodon_db_name`             | `mastodon`                            | PostgreSQL database name
`mastodon_ldap_host`           | `{{ freeipa_hosts | first }}`         | LDAP server for user authentication
`mastodon_access_group`        | `role-mastodon-access`                | FreeIPA group for Mastodon users (will be created)
`mastodon_email_from`          | `mastodon-noreply@{{ email_domain }}` | Email `From` address
`mastodon_default_locale`      | `en`                                  | Default locale
`mastodon_registrations`       | `close`                               | Registration status (either `close`, `open`, or `approved`)
`mastodon_redis_port`          | 6379                                  | Local redis port
`mastodon_web_port`            | 8008                                  | Local Web UI port
`mastodon_streaming_port`      | 8009                                  | Local Mastodon streaming port
`mastodon_sysaccount_username` | `mastodon`                            | FreeIPA [system account](../freeipa_system_account/) username
`mastodon_sysaccount_password` | &nbsp;                                | FreeIPA [system account](../freeipa_system_account/) password
`mastodon_login_cidrs`         | `[]`                                  | List of CIDRs permitted to attempt login
`mastodon_secret_key_base`     | &nbsp;                                | Secret key for browser sessions (generate with `rake secret`)
`mastodon_otp_secret`          | &nbsp;                                | Secret key for 2-factor auth (generate with `rake secret`)
`mastodon_vapid_private_key`   | &nbsp;                                | Private key for push notifications (generate with `rake mastodon:webpush:generate_vapid_key`)
`mastodon_vapid_public_key`    | &nbsp;                                | Public key for push notifications (generate with `rake mastodon:webpush:generate_vapid_key`)


This role **exports** the following variables:

Variable                 | Description
-------------------------|------------
`mastodon_webroot`       | Path to Mastodon public web directory
`mastodon_apache_config` | Apache config block for reverse proxy


Usage
-----

Example playbook:

```yaml
- name: configure mastodon servers
  hosts: mastodon_servers
  roles:
    - role: mastodon
      tags: mastodon
      vars:
        mastodon_domain: example.com
        mastodon_web_domain: mastodon.example.com
        mastodon_db_user: s-mastodon
        mastodon_db_password: s3cret
        mastodon_db_name: mastodon
        mastodon_access_group: role-mastodon-access
        mastodon_registrations: close
        mastodon_secret_key_base: s3cret
        mastodon_otp_secret: s3cret
        mastodon_vapid_public_key: AAAAchangeme
        mastodon_vapid_private_key: AAAAchangeme

    - role: apache_vhost
      apache_server_name: '{{ mastodon_web_domain }}'
      apache_server_aliases: []
      apache_letsencrypt: yes
      apache_redirect_to_https: yes
      apache_document_root: '{{ mastodon_webroot }}'
      apache_config: '{{ mastodon_apache_config }}'
      tags: apache
```
