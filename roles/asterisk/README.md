Asterisk
========

Description
-----------

The `asterisk` role installs and configures the
[Asterisk](https://www.asterisk.org/) PBX.

Variables
---------

This role **accepts** the following variables:

Variable                               | Default                                            | Description
---------------------------------------|----------------------------------------------------|------------
`asterisk_local_nets`                  | `['10.0.0.0/8', '172.16.0.0/12', 192.168.0.0/16']` | Networks local to the Asterisk server (see [documentation](https://wiki.asterisk.org/wiki/display/AST/Asterisk+17+Configuration_res_pjsip#Asterisk17Configuration_res_pjsip-transport_external_media_address))
`asterisk_external_ip`                 | &nbsp;                                             | External IP address of the Asterisk server (see [documentation](https://wiki.asterisk.org/wiki/display/AST/Asterisk+17+Configuration_res_pjsip#Asterisk17Configuration_res_pjsip-transport_external_media_address))
`asterisk_timezone`                    | `{{ timezone }}`                                   | Timezone used for voicemail metadata
`asterisk_locale`                      | `en_US.UTF-8`                                      | Locale used for voicemail prompts
`asterisk_public_fqdn`                 | `{{ ansible_fqdn }}`                               | Public FQDN of the Asterisk server (used for SIP TLS client certificate)
`asterisk_from_domain`                 | `{{ email_domain }}`                               | Domain used in SIP `From` header
`asterisk_rtp_port_start`              | 10000                                              | Minimum port used for RTP dynamic port range
`asterisk_rtp_port_end`                | 10999                                              | Maximum port used for RTP dynamic port range
`asterisk_sip_port`                    | 5060                                               | Source port for SIP connections
`asterisk_sip_tls_port`                | 5061                                               | Source port for SIP TLS connections
`asterisk_http_port`                   | 8088                                               | Listening port for the Asterisk HTTP server
`asterisk_https_port`                  | 8089                                               | Listening port for the Asterisk HTTP server (HTTPS)
`asterisk_voicemail_formats`           | `['wav49', 'gsm', 'wav']`                          | Audio formats used for voicemail recordings
`asterisk_mail_from`                   | `asterisk-noreply@{{ email_domain }}`              | Email address used for new voicemail notifications
`asterisk_voicemail_email_subject`     | see [vars.yml](defaults/vars.yml)                  | Email subject line for new voicemail notifications
`asterisk_voicemail_email_body`        | see [vars.yml](defaults/vars.yml)                  | Email body used for new voicemail notifications
`asterisk_voicemail_email_date_format` | `%A, %B %d, %Y at %r`                              | Email date format used for new voicemail notifications
`asterisk_voicemail_min_password`      | 4                                                  | Minimum voicemail password length
`asterisk_voicemail_max_message_count` | 100                                                | Maximum number of messages in each voice mailbox
`asterisk_voicemail_max_message_secs`  | 300                                                | Maximum length of voicemail message (seconds)
`asterisk_voicemail_max_greeting_secs` | 60                                                 | Maximum length of voicemail greeting (seconds)
`asterisk_voicemail_max_failed_logins` | 3                                                  | Maximum number of failed voicemail logins before lockout
`asterisk_dialplan`                    | &nbsp;                                             | Raw dialplan to place in `extensions.conf` (see [documentation](https://wiki.asterisk.org/wiki/display/AST/Contexts%2C+Extensions%2C+and+Priorities))
`asterisk_password_salt`               | &nbsp;                                             | Salt used for generating SHA-512 password hashes
`asterisk_sip_trunks`                  | `[]`                                               | Upstream SIP trunks (see format below)
`asterisk_sip_extensions`              | `[]`                                               | Local SIP extensions (see format below)
`asterisk_queues`                      | `[]`                                               | Local call queues (see format below)
`asterisk_ari_users`                   | `[]`                                               | User accounts for the Asterisk REST Interface (see format below)
`asterisk_voicemail_contexts`          | `{}`                                               | Dictionary of [voicemail contexts](https://wiki.asterisk.org/wiki/display/AST/Configuring+Voice+Mail+Boxes) (see format below)


### asterisk\_sip\_trunks

The `asterisk_sip_trunks` variable describes your upstream SIP trunks. It should
contain a list of dictionaries of the following format:

Key                | Default | Description
-------------------|---------|------------
`name`             | &nbsp;  | Name of the trunk (no spaces)
`transport`        | `udp`   | Network transport
`host`             | &nbsp;  | Remote SIP host (comma-separated `host:port`, or list)
`codecs`           | &nbsp;  | Allowed codecs (comma-separated, or list)
`media_encryption` | `"no"`  | Force media encryption (see [documentation](https://wiki.asterisk.org/wiki/display/AST/Asterisk+13+Configuration_res_pjsip#Asterisk13Configuration_res_pjsip-endpoint_media_encryption))
`username`         | &nbsp;  | SIP account username
`password`         | &nbsp;  | SIP account password


### asterisk\_sip\_extensions

The `asterisk_sip_extensions` variable describes your internal SIP extensions
(AKA your internal phone numbers). It should contain a list of dictionaries of
the following format:

Key                | Default          | Description
-------------------|------------------|------------
`name`             | &nbsp;           | Name of the extension (usually a 3- or 4-digit number)
`codecs`           | &nbsp;           | Allowed codecs (comma-separated, or list)
`context`          | &nbsp;           | Dialplan context for inbound calls
`mailbox`          | &nbsp;           | Mailbox name (comma-separated, or list)
`cid_name`         | &nbsp;           | Caller ID name
`cid_number`       | `{{ ext.name }}` | Caller ID number
`username`         | `{{ ext.name }}` | Extension SIP username
`password`         | &nbsp;           | Extension SIP password
`max_contacts`     | 1                | Maximum simultaneous logins


### asterisk\_queues

The `asterisk_queues` variable describes your [call queues](https://wiki.asterisk.org/wiki/display/AST/Building+Queues).
 It should contain a list of dictionaries of the following format:

Key                | Default          | Description
-------------------|------------------|------------


### asterisk\_ari\_users

The `asterisk_ari_users` variable describes user accounts for the [Asterisk REST Interface](https://wiki.asterisk.org/wiki/pages/viewpage.action?pageId=29395573).
It should contain a list of dictionaries of the following format:

Key         | Default | Description
------------|---------|------------
`name`      | &nbsp;  | Username
`password`  | &nbsp;  | Password
`read_only` | yes     | Limit account to read-only requests


### asterisk\_voicemail\_contexts

The `asterisk_voicemail_contexts` variable describes your [voicemail contexts](https://wiki.asterisk.org/wiki/display/AST/Configuring+Voice+Mail+Boxes).
It should contain a mapping of context names to dictionaries of the following format:

Key        | Default | Description
-----------|---------|------------
`address`  | &nbsp;  | Mailbox address (usually a 3- or 4-digit number) 
`password` | &nbsp;  | Initial mailbox password (usually a numeric PIN)
`name`     | &nbsp;  | Human-readable mailbox name
`email`    | &nbsp;  | Email address for new voicemail notifications (or list)


### Exports

This role **exports** the following variables:

Variable            | Description
--------------------|------------
`asterisk_data_dir` | Path to asterisk data files (voicemails, etc)


Usage
-----

Example playbook:

````yaml
- hosts: asterisk_servers
  roles:
    - role: asterisk
      vars:
        asterisk_local_nets:
          - 192.168.1.0/24
````
