Prosdy
======

Description
-----------

The `prosody` role installs and configures the [Prosody](https://prosody.im/)
XMPP server.

Modern XMPP features are supported, like
[client state indication](https://prosody.im/doc/modules/mod_csi),
[message carbons](https://prosody.im/doc/modules/mod_carbons),
[message archive management](https://prosody.im/doc/modules/mod_mam), and
[HTTP file upload](https://modules.prosody.im/mod_http_upload).

Users authenticate against the local FreeIPA domain using
[mod\_auth\_ldap](https://prosody.im/doc/modules/mod_auth_ldap).
Rosters are automatically populated with all local users via a
[script](templates/usr/local/bin/prosody-update-roster.j2).

The Jabber ID for each user is taken from the `jid` attribute of the FreeIPA
User object.


### Certificates

XMPP certificates are a bit unusual. Clients expect a server to present a
certificate for the _JID domain_, rather than for the FQDN of the XMPP server.

For example, if your JID is `user@example.com` with XMPP server `xmpp.example.com`,
your XMPP server actually needs a certificate for the bare domain `example.com`!

Unless you run your XMPP server and webserver on the same host, this poses a
problem for LetsEncrypt certificates.

I didn't want to deal with DNS challenges for just this one use-case, so I made
the [prosody\_letsencrypt\_proxy](../prosody_letsencrypt_proxy) role to retrieve
certificates from an existing webserver.


Variables
---------

This role **accepts** the following variables:

Variable                         | Default                    | Description
---------------------------------|----------------------------|------------
`prosody_admins`                 |  `[]`                      | JIDs of server admins
`prosody_vhosts`                 |  `['{{ email_domain }}']`  | XMPP domains to serve
`prosody_conference_vhosts`      |  `conference.{{ vhosts }}` | XMPP conference domains (usually `conference.example.com`)
`prosody_user`                   |  `s-prosody`               | Prosody FreeIPA user (will be created)
`prosody_db_name`                |  `prosody`                 | Prosody database name (will be created)
`prosody_db_host`                | `{{ postgresql_host }}`    | Prosody database host
`prosody_archive_expires_after`  |  `4w`                      | How long to keep message archives
`prosody_http_port`              |  5280                      | Local port for HTTP server
`prosody_http_host`              |  `{{ ansible_fqdn }}`      | Public HTTP hostname
`prosody_sysaccount_username`    |  `prosody`                 | FreeIPA [sysaccount](https://www.freeipa.org/page/HowTo/LDAP#System_Accounts) uid for LDAP authentication
`prosody_sysaccount_password`    |  &nbsp;                    | FreeIPA [sysaccount](https://www.freeipa.org/page/HowTo/LDAP#System_Accounts) password
`prosody_ldap_hosts`             | `{{ freeipa_hosts }}`      | FreeIPA LDAP hosts
`prosody_access_group`           | `role-xmpp-access`         | FreeIPA group for users allowed XMPP access (will be created)
`prosody_upload_file_size_limit` | 52428800                   | HTTP upload size limit (bytes)
`prosody_upload_expire_after`    | 604800                     | How long to keep file uploads (seconds)
`prosody_upload_quota`           | 10737418240                | Per-user upload quota (bytes)
`prosody_turn_secret`            | `{{ coturn_auth_secret }}` | [TURN server](https://prosody.im/doc/turn) secret
`prosody_turn_host`              | `{{ coturn_realm }}`       | [TURN server](https://prosody.im/doc/turn) public hostname
`prosody_turn_port`              | 3478                       | [TURN server](https://prosody.im/doc/turn) port


Usage
-----

Example playbook:

````yaml
- name: configure prosody
  hosts: xmpp_servers
  roles:
    - role: prosody
      vars:
        prosody_admins:
          - johndoe@example.com
          - greybeard@example.net
        prosody_vhosts:
          - example.com
          - example.net
        prosody_http_host: xmpp.example.com
        prosody_access_group: jabber-users
        prosody_turn_host: turn.example.com
        prosody_turn_secret: s3cret
        prosody_db_host: postgres.ipa.example.com
        

````
