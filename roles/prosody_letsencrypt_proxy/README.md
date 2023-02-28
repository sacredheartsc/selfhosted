Prosody LetsEncrypt Proxy
=========================

Description
-----------

The `prosody_letsencrypt_proxy` role is used to copy certificates from your
webserver to your XMPP server.

Because XMPP clients require certificates matching the bare JID domain, it's
difficult to acquire LetsEncrypt certificates unless your XMPP and web server
are on the same host.

This role has two modes: `master` and `slave`.

The `master` mode should be run on your domain's webserver. Certificates are
retrieved from LetsEncrypt via Certbot, and placed in a special `sftp`-accessible
location.

The `slave` mode should be run on your XMPP host. It periodically scrapes the
new certificates from the `master`, and reloads Prosody if necessary.


Variables
---------

This role **accepts** the following variables:

Variable                 | Default                | Description
-------------------------|------------------------|------------
`prosody_le_role`        | `slave`                | Either `master` or `slave`
`prosody_le_domains`     | `{{ prosody_vhosts }}` | XMPP domains
`prosody_le_proxy_host`  | &nbsp;                 | Host to retrieve certificates from
`prosody_le_ssh_privkey` | &nbsp;                 | SSH private key for SFTP
`prosody_le_ssh_pubkey`  | &nbsp;                 | SSH public key for SFTP

Usage
-----

Example playbook:

````yaml
- name: configure webserver
  hosts: www1
  roles:
    - role: apache_vhost
      apache_server_name: www.example.com
      apache_server_aliases: [example.com]
      apache_canonical_hostname: www.example.com
      apache_document_root: /var/www/www.example.com
      apache_letsencrypt: yes

    - role: prosody_letsencrypt_proxy
      vars:
        prosody_le_role: master
        prosdy_le_domains:
          - example.com
        prosody_le_pubkey: |
          -----BEGIN OPENSSH PUBLIC KEY-----
          AAAAAAAAetc

- name: configure prosody
  hosts: xmpp_servers
  roles:
    - role: prosody
      vars:
        prosody_vhosts:
          - example.com
        prosody_le_role: slave
        prosdy_le_proxy_host: www1
        prosody_ssh_privkey: |
          -----BEGIN OPENSSH PRIVATE KEY-----
          AAAAAAAAetc
````
