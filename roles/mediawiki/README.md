MediaWiki
=========

Description
-----------

The `mediawiki` role installs and configures [MediaWiki](https://www.mediawiki.org/wiki/MediaWiki),
an open source wiki server.

This role configures the PHP application only; it does not configure a reverse
proxy.


Variables
---------

This role **accepts** the following variables:

Variable                           | Default                                                          | Description
-----------------------------------|------------------------------------------------------------------|------------
`mediawiki_version`                | see [default vars](defaults/main.yml)                            | MediaWiki version to install
`mediawiki_extension_version`      | see [default vars](defaults/main.yml)                            | MediaWiki extension version
`mediawiki_kerberized_cidrs`       | `{{ kerberized_cidrs }}`                                         | Client networks which support GSSAPI authentication
`mediawiki_user`                   | `s-mediawiki`                                                    | FreeIPA user account for MediaWiki (will be created)
`mediawiki_db_name`                | `mediawiki`                                                      | PostgreSQL database name
`mediawiki_db_host`                | `{{ postgresql_host }}`                                          | PostgreSQL hostname
`mediawiki_access_group`           | `role-wiki-access`                                               | FreeIPA group of MediaWiki users (will be created)
`mediawiki_admin_group`            | `role-wiki-admin`                                                | FreeIPA group of MediaWiki administrators (will be created)
`mediawiki_max_upload_size`        | `50M`                                                            | Maximum file upload size
`mediawiki_max_upload_count`       | 32                                                               | Maximum simultaneous uploads per client
`mediawiki_custom_namespaces`      | `[]`                                                             | List of custom namespaces (see [format](#mediawiki_custom_namespaces) below)
`mediawiki_use_subpages`           | yes                                                              | Allow hierarchical pages
`mediawiki_ldap_servers`           | `{{ freeipa_hosts }}`                                            | FreeIPA LDAP hosts
`mediawiki_sysaccount_username`    | `mediawiki`                                                      | FreeIPA [system account](../freeipa_system_account/) username
`mediawiki_sysaccount_password`    | &nbsp;                                                           | FreeIPA [system account](../freeipa_system_account/) password
`mediawiki_site_name`              | `{{ organization }} Wiki`                                        | Name of wiki
`mediawiki_meta_namespace`         | `{{ organization }}` without whitespace                          | Name of the [meta namespace](https://www.mediawiki.org/wiki/Manual:$wgMetaNamespace)
`mediawiki_fqdn`                   | `{{ ansible_fqdn }}`                                             | Canonical HTTP hostname
`mediawiki_admin_username`         | `admin`                                                          | Username for built-in admin account
`mediawiki_admin_password`         | &nbsp;                                                           | Password for built-in admin account
`mediawiki_emergency_contact`      | `root@{{ email_domain }}`                                        | [Emergency contact](https://www.mediawiki.org/wiki/Manual:$wgEmergencyContact) for wiki
`mediawiki_password_sender`        | `wiki-noreply@{{ email_domain }}`                                | Email `From:` address for [password reminders](https://www.mediawiki.org/wiki/Manual:$wgPasswordSender)
`mediawiki_email_authentication`   | no                                                               | Require [email address confirmation](https://www.mediawiki.org/wiki/Manual:$wgEmailAuthentication)
`mediawiki_local_timezone`         | `{{ timezone }}`                                                 | [Timezone](https://www.mediawiki.org/wiki/Manual:$wgLocaltimezone) of the wiki
`mediawiki_language_code`          | `en`                                                             | [Language code](https://www.mediawiki.org/wiki/Manual:$wgLanguageCode) of the wiki
`mediawiki_default_skin`           | `vector`                                                         | Default skin
`mediawiki_default_mobile_skin`    | `minerva`                                                        | Default skin for mobile devices
`mediawiki_disable_anonymous_read` | no                                                               | Disable anonymous read access
`mediawiki_disable_anonymous_edit` | yes                                                              | Disable anonymous write access
`mediawiki_apc_shm_size`           | `256M`                                                           | PHP opcode cache size
`mediawiki_skins`                  | `['Vector', 'MinervaNeue']`                                      | Skins to install
`mediawiki_logo_1x`                | &nbsp;                                                           | Path to 1x-size [logo](https://www.mediawiki.org/wiki/Manual:$wgLogos)
`mediawiki_logo_icon`              | &nbsp;                                                           | Path to icon-size [logo](https://www.mediawiki.org/wiki/Manual:$wgLogos)
`mediawiki_logo_favicon`           | &nbsp;                                                           | Path to [favicon](https://www.mediawiki.org/wiki/Manual:$wgFavicon)

### mediawiki\_custom\_namespaces

The `mediawiki_custom_namespaces` variable is used to create [custom namespaces](https://www.mediawiki.org/wiki/Manual:Using_custom_namespaces)
with their own permission schemes.  It should contain a list of dictionaries of
the following format:

Key         | Default | Description
------------|---------|------------
`namespace` | &nbsp;  | Namespace name
`id`        | &nbsp;  | Even namespace ID between 3000-4999
`talk_id`   | &nbsp;  | This **must** be the following odd integer
`restrict`  | `{}`    | Mapping of MediaWiki [permission](https://www.mediawiki.org/wiki/Manual:User_rights#List_of_permissions) (or `*`) to group names

### Exports

This role **exports** the following variables:

Variable                     | Description
-----------------------------|------------
`mediawiki_home`             | Path to MediaWiki installation
`mediawiki_apache_config`    | Apache config block for MediaWiki
`mediawiki_php_environment`  | Dictionary of required environment variables for PHP
`mediawiki_php_admin_values` | Dictionary of required admin values for PHP
`mediawiki_archive_shell`    | Shell command to generate backup tarball


Usage
-----

Example playbook:

````yaml
- name: configure mediawiki
  hosts: wiki_servers
  roles:
    - role: mediawiki
      vars:
        mediawiki_site_name: Example Wiki
        mediawiki_site_fqdn: wiki.example.com
        mediawiki_logo_1x: ~/assets/mediawiki_1x.png
        mediawiki_logo_icon: ~/assets/mediawiki_icon.png
        mediawiki_favicon: ~/assets/mediawiki_favicon.ico
        mediawiki_custom_namespaces:
          - namespace: HumanResources
            id: 3000
            talk_id: 3001
            restrict:
              '*': ['hr']
              'read': ['legal', 'bookkeeping']

    - role: apache_vhost
      apache_default_vhost: yes
      apache_document_root: '{{ mediawiki_home }}'
      apache_config: '{{ mediawiki_apache_config }}'

    - role: php
      php_fpm_environment: '{{ mediawiki_php_environment }}'
      php_fpm_admin_values: '{{ mediawiki_php_admin_values }}'
````
