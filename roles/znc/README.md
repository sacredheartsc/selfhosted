ZNC
===

Description
-----------

The `znc` role installs and configures the [ZNC](https://znc.in/) IRC bouncer.
The ZNC application provides both an IRC server and web GUI for configuration.
User authentication is performed using FreeIPA.

Variables
---------

This role **accepts** the following variables:

Variable           | Default          | Description
-------------------|------------------|------------
`znc_irc_port`     | 6697             | IRC port
`znc_https_port`   | 8443             | Local listening port for web interface
`znc_max_networks` | 10               | Maximum IRC networks per user
`znc_access_group` |`role-znc-access` | FreeIPA group for ZNC users (will be created)

This role **exports** the following variables:

Variable            | Description
--------------------|------------
`znc_archive_shell` | Shell command to create ZNC backup tarball

Usage
-----

Example playbook:

````yaml
- name: configure znc
  hosts: znc_servers
  roles:
    - role: znc
      vars:
        znc_access_group: znc-users
````
