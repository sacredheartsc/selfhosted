Syncthing
=========

Description
-----------

The `syncthing` role installs [Syncthing](https://syncthing.net/) and
configures a dedicated Syncthing instance for each specified user.

Using the exported `syncthing_apache_config` block, users are able to access
their server GUI by navigating to `https://$HOSTNAME/$USERNAME/` (GSSAPI
authentication is used).

Note that if you use NFS home directories, you'll need to whitelist the
Syncthing host for non-Kerberized NFS. Each user's Syncthing instance runs
under their own UID, and I haven't yet figured out a good way to shuffle
keytabs around.


Variables
---------

This role **accepts** the following variables:

Variable                        | Default | Description
--------------------------------|---------|------------
`syncthing_users`               | `{}`    | Mapping of usernames to unique Syncthing ports
`syncthing_fs_watcher_enabled`  | no      | Use inotify (doesn't work on NFS)
`syncthing_rescan_interval_sec` | 60      | Folder rescan interval (seconds)

This role **exports** the following variables:

Variable                  | Description
--------------------------|------------
`syncthing_archive_shell` | Shell command to make a backup tarball of the Syncthing configuration

Usage
-----

Example playbook:

````yaml
- name: configure syncthing
  hosts: syncthing1
  roles:
    - role: syncthing
      vars:
        syncthing_users:
          johndoe: 22001
          janedoe: 22002
          anotheruser: 22003

    - role: apache_vhost
      apache_default_vhost: yes
      apache_config: '{{ syncthing_apache_config }}'
````
