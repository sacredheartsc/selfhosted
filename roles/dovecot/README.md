Dovecot
=======

Description
-----------

The `dovecot` role installs and configures the [Dovecot](https://www.dovecot.org/)
IMAP server.

IMAPS will be configured for Kerberos/GSSAPI authentication, as well as
plain-text username/password. A LMTP port is opened for Postfix to deliver
mail.

Global sieve scripts are provided which automatically train emails as SPAM or
or HAM whenever a user moves messages in or out of his Junk folder, using
[rspamd](../rspamd/).

This role also configures [Apache Solr](../solr/) for full-text search and
[Apache Tika](../tika/) for attachment indexing.


Variables
---------

This role **accepts** the following variables:

Variable                        | Default                 | Description
--------------------------------|-------------------------|------------
`dovecot_recipient_delimiter`   | `+`                     | Character delimiter for email address extensions
`dovecot_default_user_quota`    | `5G`                    | Default mailbox quota
`dovecot_quota_grace_percent`   | 5                       | Allow users to go a percentage over their quota
`dovecot_default_domain`        | `{{ email_domain }}`    | Domain used for outgoing mails (quota warnings, etc)
`dovecot_rspamd_host` '         | `{{ rspamd_host }}`     | Hostname of rspamd instance
`dovecot_rspamd_password`       | `{{ rspamd_password }}` | Password for rspamd instance
`dovecot_rspamd_pubkey`         | `{{ rspamd_pubkey }}`   | Pubkey for rspamc encryption
`dovecot_access_group`          | `role-imap-access`      | FreeIPA group for users allowed IMAP access (will be created)
`dovecot_lmtp_port`             | 24                      | LMTP port (used by Postfix)
`dovecot_quota_status_port`     | 10993                   | Quota status port (used by Postfix)
`dovecot_tika_port`             | 9998                    | Local Tika port (attachment indexing)
`dovecot_solr_port`             | 8983                    | Local Solr port (full-text search database)
`dovecot_max_mail_size`         | `64M`                   | Maximum email size
`dovecot_quota_warning_percent` | `[95,90,80]`            | Warn users via email when mailbox reaches quota percentage

This role **exports** the following variables:

Variable             | Description
---------------------|------------
`dovecot_vmail_user` | Unix user used to store mailbox data
`dovecot_vmail_dir`  | Path to mailboxes


Usage
-----

Example playbook:

````yaml
- hosts: imap_servers
  roles:
    - role: dovecot
      vars:
        dovecot_default_user_quota: 20G
        dovecot_rspamd_host: rspamd.example.com
        dovecot_rspamd_password: s3cret
        dovecot_rspamd_pubkey: AAAAAasdf
        dovecot_access_group: imap-users
````
