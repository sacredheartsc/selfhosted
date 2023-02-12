Evolution
=========

Description
-----------

The `evolution` role configures [autoconfig](https://wiki.gnome.org/Apps/Evolution/Autoconfig)
files for the [Evolution](https://wiki.gnome.org/Apps/Evolution) mail/calendar
application.

When a user starts Evolution for the first time, accounts will automatically be
added for the local IMAP, SMTP, CalDAV, and CardDAV servers,
using GSSAPI for authentication.


Variables
---------

This role **accepts** the following variables:

Variable                      | Default              | Description
------------------------------|----------------------|------------
`evolution_mail_account_name` | `{{ organization }}` | Name of the mail account
`evolution_dav_account_name`  | `{{ organization }}` | Name of the CalDAV/CardDAV account
`evolution_email_domain`      | `{{ email_domain }}` | Domain used to construct the email address from `$USER`
`evolution_imap_host`         | `{{ imap_host }}`    | IMAP hostname
`evolution_smtp_host`         | `{{ mail_host }}`    | SMTP hostname
`evolution_dav_host`          | `dav.{{ domain }}`   | CalDAV/CardDAV hostname


Usage
-----

Example playbook:

````yaml
- hosts: linux_desktops
  roles:
    - role: evolution
      vars:
        evolution_imap_host: imap.example.com
        evolution_smtp_host: smtp.example.com
        evolution_dav_host: dav.example.com
        evolution_email_domain: example.com
````
