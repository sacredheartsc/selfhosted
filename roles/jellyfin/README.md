Jellyfin
========

Description
-----------

The `jellyfin` role installs the [Jellyfin](https://jellyfin.org/) media browser.
This role will generate the config file for the Jellyfin [LDAP authentication plugin](https://github.com/jellyfin/jellyfin-plugin-ldapauth),
but you'll have to install the plugin yourself through the admin panel.

This role configures the application only; it does not configure a reverse
proxy.


Variables
---------

This role **accepts** the following variables:

Variable                       | Default                               | Description
-------------------------------|---------------------------------------|------------
`jellyfin_version`             | see [default vars](defaults/main.yml) | Jellyfin version to install
`jellyfin_port`                | 8096                                  | Local listening port
`jellyfin_user`                | `s-jellyfin`                          | FreeIPA account for Jellyfin process (will be created)
`jellyfin_sysaccount_username` | `jellyfin`                            | [System account](../freeipa_system_account) username for LDAP binds
`jellyfin_sysaccount_password` | &nbsp;                                | [System account](../freeipa_system_account) password for LDAP binds
`jellyfin_media_access_group`  | `role-media-access`                   | FreeIPA group used for Jellyfin user to access media files (will be created)
`jellyfin_access_group`        | `role-media-access`                   | FreeIPA group of users allowed to access Jellyfin (will be created)
`jellyfin_admin_group`         | `role-media-admin`                    | FreeIPA group of Jellyfin administrators (will be created)
`jellyfin_ldap_servers`        | `{{ freeipa_hosts }}`                 | Hostnames of FreeIPA LDAP servers


This role **exports** the following variables:

Variable                  | Description
--------------------------|------------
`jellyfin_apache_config`  | Apache config block for reverse proxy

Usage
-----

Example playbook:

````yaml
- hosts: invidious_servers
  roles:
    - role: jellyfin

    - role: apache_vhost
      vars:
        apache_server_name: jellyfin.ipa.example.com
        apache_config: '{{ jellyfin_apache_config }}'
````
