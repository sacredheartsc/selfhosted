Synapse
======

Description
-----------

The `synapse` role installs and configures the [synapse](https://github.com/matrix-org/synapse/)
homeserver for the [Matrix](https://matrix.org/) network.

Users authenticate against the local FreeIPA domain using
the [matrix-synapse-ldap3](https://github.com/matrix-org/matrix-synapse-ldap3) plugin.
The Matrix username for each user is taken from the `matrixUsername` attribute
of the FreeIPA User object.

If your Matrix domain differs from the public hostname of your synapse server
(e.g. your MXIDs have the format `@user:example.com`, but synapse runs on
`matrix.example.com`), then you will need to configure `.well-known` delegation
in order to federate with other instances. See the [sample webserver playbook](../../playbooks/webserver_public_example.yml)
for an example of how to do this.

The secrets can be generated using `python -m synapse.app.homeserver --generate-config`.


Variables
---------

This role **accepts** the following variables:

Variable                             | Default                                      | Description
-------------------------------------|----------------------------------------------|------------
`synapse_version`                    | see [defaults](defaults/main.yml)            | [synapse](https://github.com/matrix-org/synapse/) version to install
`synapse_ldap_version`               | see [defaults](defaults/main.yml)            | [synapse ldap](https://github.com/matrix-org/matrix-synapse-ldap3) plugin version to install
`synapse_element_version`            | see [defaults](defaults/main.yml)            | [element-web](https://github.com/vector-im/element-web) version to install
`synapse_domain`                     | `{{ email_domain }}`                         | Matrix domain served by the homeserver
`synapse_server_name`                | `{{ ansible_fqdn }}`                         | Public hostname of the homeserver
`synapse_local_client_port`          | 8008                                         | Localhost listen port for client traffic
`synapse_local_federation_port`      | 8009                                         | Localhost listen port for federation traffic
`synapse_client_port`                | 8443                                         | Public listen port for client traffic
`synapse_federation_port`            | 8448                                         | Public listen port for federation traffic
`synapse_user`                       | `s-synapse`                                  | FreeIPA user (will be created)
`synapse_access_group`               | `role-matrix-access`                         | FreeIPA group for Matrix users (will be created)
`synapse_db_host`                    | `{{ postgresql_host }}`                      | PostgreSQL host
`synapse_db_name`                    | `synapse`                                    | PostgreSQL database (will be created)
`synapse_sysaccount_username`        | `synapse`                                    | FreeIPA [system account](../freeipa_system_account/) username
`synapse_sysaccount_password`        | &nbsp;                                       | FreeIPA [system account](../freeipa_system_account/) password
`synapse_registration_shared_secret` | &nbsp;                                       | Secret passphrase to allow registration even when disabled (optional)
`synapse_macaroon_secret_key`        | &nbsp;                                       | Secret signing key for various tokens (required)
`synapse_form_secret`                | &nbsp;                                       | Secret key for various form HMACs (required)
`synapse_signing_key`                | &nbsp;                                       | Signing key (required)
`synapse_turn_host`                  | `{{ coturn_realm }}`                         | TURN server hostname
`synapse_turn_secret`                | `{{ coturn_auth_secret }}`                   | TURN server shared secret
`synapse_enable_email_notifications` | yes                                          | Enable email notifications
`synapse_email_from`                 | `Matrix <matrix-noreply@{{ email_domain }}>` | Email `From` address
`synapse_enable_registration`        | no                                           | Enable new user registration
`synapse_max_upload_size`            | `50m`                                        | Maxiumum file upload size
`synapse_auto_join_rooms`            | `[]`                                         | Local rooms to join automatically
`synapse_url_preview_blacklist`      | see [defaults](defaults/main.yml)            | List of CIDRs to block from URL previews
`synapse_url_preview_whitelist`      | `[]`                                         | List of CIDRs to allow for URL previews

This role **exports** the following variables:

Variable                           | Description
-----------------------------------|------------
`synapse_element_webroot`          | Path to [element-web](https://github.com/vector-im/element-web) directory
`synapse_apache_client_config`     | Apache config block for client reverse proxy
`synapse_apache_federation_config` | Apache config block for federation reverse proxy
`synapse_archive_shell`            | Shell command for generating tarball of media files


Usage
-----

The following example playbook installs synapse and configures an Apache
reverse proxy. The client API is served on port 8443, the federation API
is served on port 8448, and the Element web client is served on the standard
HTTPS port.

````yaml
- name: configure synapse matrix homeserver
  hosts: matrix_servers
  vars:
    synapse_domain: example.com
    synapse_server_name: matrix.example.com
    synapse_client_port: 8443
    synapse_federation_port: 8448
    synapse_access_group: role-example-matrix-access
    synapse_macaroon_secret_key: s3cret
    synapse_form_secret: s3cret
    synapse_sysaccount_password: s3cret
    synapse_turn_host: turn.example.com
    synapse_turn_secret: s3cret
    synapse_email_from: 'Matrix <matrix-noreply@example.com>'
    synapse_enable_registration: no
  roles:
    - role: synapse
      tags: synapse

    - role: apache_vhost
      apache_server_name: '{{ synapse_server_name }}'
      apache_server_aliases: []
      apache_ssl_only: yes
      apache_letsencrypt: yes
      apache_listen_port: '{{ synapse_federation_port }}'
      apache_config: '{{ synapse_apache_federation_config }}'
      apache_config_name: '{{ synapse_server_name }}-federation'
      tags: apache

    - role: apache_vhost
      apache_server_name: '{{ synapse_server_name }}'
      apache_server_aliases: []
      apache_ssl_only: yes
      apache_letsencrypt: yes
      apache_listen_port: '{{ synapse_client_port }}'
      apache_config: '{{ synapse_apache_client_config }}'
      apache_config_name: '{{ synapse_server_name }}-client'
      tags: apache

    - role: apache_vhost
      apache_server_name: '{{ synapse_server_name }}'
      apache_server_aliases: []
      apache_letsencrypt: yes
      apache_redirect_to_https: yes
      apache_document_root: '{{ synapse_element_webroot }}'
      apache_config_name: '{{ synapse_server_name }}-element'
      tags: apache
````
