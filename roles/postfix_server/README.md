Postfix Server
==============

Description
-----------

The `postfix_server` role installs [Postfix](https://www.postfix.org/) as a
mail server for both internal and public-facing email.

To reliably deliver email to others, a few things are necessary.

  1. Your mail server should have a public IP address with a good reputation.
     Services like [MX Toolbox](https://mxtoolbox.com/blacklists.aspx) let you
     check your IP address against various blacklists.

  2. Your mail server's IP address should have a "real" PTR record, ideally one
     that resolves back to the correct IP address. Reverse DNS records like
     `4.3.2.1.your-isp.com` will usually cause your outgoing email to be rejected.

  3. Your email domain should have an [MX record](https://en.wikipedia.org/wiki/MX_record)
     designating your mail server as the domain's mail exchanger.

  4. Your email domain should have an [SPF record](https://en.wikipedia.org/wiki/Sender_Policy_Framework)
     in DNS that designates your mail server as a permitted sender.

  5. Your email domain should have a [DKIM record](https://en.wikipedia.org/wiki/DomainKeys_Identified_Mail)
     in DNS that allows clients to cryptographically verify that your outgoing
     mail is legitimate. DKIM signing in our setup is handled by [rspamd](../rspamd/).

  6. Your email domain should have a [DMARC record](https://en.wikipedia.org/wiki/DMARC)
     in DNS that designates how your outgoing mail should be validated by other
     mail servers.

FreeIPA Integration
-------------------

This role configures Postfix to use FreeIPA's LDAP directory as a source for
virtual mailboxes and aliases. Specifically:

  - Postfix will deliver mail for FreeIPA users based on the user's `mail` attribute.

  - You can send mail to all members of a FreeIPA group by adding a `mail`
    attribute to the group object.

  - You can add mail aliases for users and groups by adding one or more
    `mailAlternateAddress` attributes to the LDAP object.


Variables
---------

This role **accepts** the following variables:

Variable                        | Default                       | Description
--------------------------------|-------------------------------|------------
`postfix_message_size_limit`    | 67108864                      | Maximum message size (bytes)
`postfix_recipient_delimiter`   | `+`                           | Character delimiter for email address extensions
`postfix_lmtp_require_tls`      | yes                           | Require verified TLS for LMTP delivery to Dovecot
`postfix_virtual_domains`       | `['{{ email_domain }}']`      | Accept mail for the specified domains (see [documentation](https://www.postfix.org/postconf.5.html#virtual_mailbox_domains))
`postfix_myorigin`              | `{{ email_domain }}`          | Default sender domain (see [documentation](https://www.postfix.org/postconf.5.html#myorigin))
`postfix_mynetworks`            | `vlans` CIDRs                 | Clients that can relay mail (see [documentation](https://www.postfix.org/postconf.5.html#mynetworks))
`postfix_myhostname`            | `{{ ansible_fqdn }}`          | Public-facing FQDN (see [documentation](https://www.postfix.org/postconf.5.html#myhostname))
`postfix_lmtp_host`             | `{{ imap_host }}`             | LMTP host for local mail delivery (see [dovecot](../dovecot/))
`postfix_lmtp_port`             | 24                            | LMTP port (see [dovecot](../dovecot/))
`postfix_quota_host`            | `{{ postfix_lmtp_host }}`     | Quota service host (see [dovecot](../dovecot/))
`postfix_quota_port`            | 10993                         | Quota service port (see [dovecot](../dovecot/))
`postfix_rspamd_host`           | `{{ rspamd_host }}`           | Rspamd milter host (see [rspamd](../rspamd/))
`postfix_rspamd_port`           | 11332                         | Rspamd milter port (see [rspamd](../rspamd/))
`postfix_recipient_group`       | `role-imap-access`            | FreeIPA group of users allowed to receive mail (will be created)


Usage
-----

Example playbook:

````yaml
- hosts: mail_servers
  roles:
    - role: postfix_server
      vars:
        postfix_virtual_domains:
          - example.com
          - example.net
        postfix_mynetworks:
          - 10.10.10.0/24
          - 10.10.11.0/24
        postfix_myhostname: mx1.example.com
        postfix_lmtp_host: imap.ipa.example.com
        postfix_rspamd_host: rspamd.ipa.example.com
        postfix_relayhost: '[mx1.example.com]:25'
        postfix_recipient_group: mail-recipients
````
