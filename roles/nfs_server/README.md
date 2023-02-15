NFS Server
==========

Description
-----------

The `nfs_server` role creates [zfs](../zfs/) filesystems, configures NFS and SMB
shares, adds `autofs` entries, and sets POSIX permissions and ACLs on the
corresponding directories.

This role also manages home directories, which are considered a special case.
Both users and groups can have home directories. User home directories are
owned by the user, whereas group home directories are group-owned by the group.
In either case, two subdirectories are created: `priv` and `pub`.

The `priv` directory is private to the user or group, while the `pub` directory
is world-readable. Both of directories get added to the automount map
`auto.nfs_user`, but the `priv` directory is also is automounted as `/home/$USER`.

This role was written with the assumption that you're using ZFS for the
underlying storage.

The lists and mappings in the variables in the role are somewhat complex. It's
probably easiest to start with the example playbook in the [Usage](#usage)
section at the bottom of this document.

Variables
---------

This role **accepts** the following variables:

Variable                    | Default      | Description
----------------------------|--------------|------------
`nfs_mountd_port`           | `20048`      | NFS `mountd` listening port
`nfs_exports`               | `[]`         | NFS exports to create (see [format](#nfs_exports) below)
`smb_shares`                | `[]`         | SMB shares to create (see [format](#smb_shares) below)
`nfs_homedirs`              | `[]`         | Home directories to create (see [format](#nfs_homedirs) below)
`nfs_homedir_user_dataset`  | `tank/user`  | ZFS dataset for user home directories
`nfs_homedir_group_dataset` | `tank/group` | ZFS dataset for group directories
`nfs_homedir_priv_quota`    | `50G`        | Default usage quota for private home/group directories
`nfs_homedir_pub_quota`     | `10G`        | Default usage quota for public home/group directories
`nfs_homedir_options`       | `rw`         | Export options for home/group directories
`nfs_homedir_clients`       | `[]`         | NFS clients for home/group directories (see [format](#nfs_homedir_clients) below)

### nfs\_exports

The `nfs_exports` variable is used to configure NFS shares. It
should contain a list of dictionaries of the following format:

Key             | Default            | Description
----------------|--------------------|-----------
`path`          | &nbsp;             | Path of export
`dataset`       | &nbsp;             | ZFS dataset to export
`group`         | &nbsp;             | Group owner for directory
`mode`          | &nbsp;             | Octal permissions for directory
`acl`           | `[]`               | List of POSIX ACL entries for directory (see [format](#acl) below)
`options`       | `[]`               | Export options (comma-separated or list, see `man 5 exports`)
`clients`       | `[]`               | List of clients (see [format](#clients) below)
`automount_map` | &nbsp;             | Automount map name for export
`automount_key` | basename of `path` | Automount key name for export
`smb_share`     | &nbsp;             | Also create SMB share with given share name

Either `path` or `dataset` should be specified, but not both.

#### acl

The `acl` key of an `nfs_exports` list item should contain a list of POSIX
ACLS, represented by dictionaries of the following format:

Key           | Default | Description
--------------|---------|------------
`entity`      | &nbsp;  | User or group name
`etype`       | &nbsp;  | Entity type (either `user` or `group`)
`permissions` | &nbsp;  | Some combination of `r`, `w`, `x`, or `X`
`default`     | no      | Apply ACL to all children of directory

See `man 5 acl` for more details.

#### clients

The `clients` key of an `nfs_exports` list item should contain a list of NFS
clients, represented by dictionaries of the following format:

Key        | Default | Description
-----------|---------|------------
`client`   | &nbsp;  | Client CIDR, IP address, or hostname
`options`  | &nbsp;  | Client-specific export options (comma-separated or list, see `man 5 exports`)

### smb\_shares

The `smb_shares` variable is used to configure SMB shares. It should contain a
list of dictionaries of the following format:

Key        | Default | Description
-----------|---------|------------
`name`     | &nbsp;  | Share name
`path`     | &nbsp;  | Share path

### nfs\_homedirs

The `nfs_homedirs` variable is used to configure user and group home
directories that should live on the host. It should contain a list of
dictionaries of the following format:

Key          | Default                        | Description
-------------|--------------------------------|------------
`user`       | &nbsp;                         | User name
`group`      | &nbsp;                         | Group name
`priv_quota` | `{{ nfs_homedir_priv_quota }}` | `priv` directory quota
`pub_quota`  | `{{ nfs_homedir_pub_quota }}`  | `pub` directory quota

Specifying `user` creates a user home directory. Specifying `group` creates a
group home directory. You should not specify `user` and `group` at the same
time.

### nfs\_homedir\_clients

The `nfs_homedir_clients` variable is used to configure client access for home
directory exports. It should contain a list of dictionaries of the following
format:

Key       | Default    | Description
----------|------------|------------
`client`  | &nbsp;     | Client IP, CIDR, or hostname
`options` | `[]`       | Export options (comma-separated or list, see `man 5 exports`)


Usage
-----

Example playbook:

````yaml
- hosts: nas1
  roles:
    - role: nfs_server
      vars:
        nfs_exports:
          - dataset: tank/media/pictures
            group: role-photo-admin
            mode: 02770
            acl:
              - entity: role-photo-admin
                etype: group
                permissions: rwX
                default: yes
            options: rw,crossmnt
            clients:
              - client: 10.10.10.0/24
                options: sec=krb5p
            automount_map: auto.nfs_media

          - dataset: tank/media/music
            group: role-music-admin
            mode: 02770
            acl:
              - entity: role-music-admin
                etype: group
                permissions: rwX
                default: yes

              - entity: role-music-access
                etype: group
                permissions: rX
                default: yes
            options: rw,crossmnt
            clients:
              - client: 10.10.10.0/24
                options: sec=krb5p
            automount_map: auto.nfs_media

        nfs_homedir_clients:
          - client: 10.10.10.0/24
            options: sec=krb5p

          - client: 10.10.11.0/24
            options: sec=sys

        nfs_homedirs:
          - user: johndoe
            priv_quota: 250G
          - user: janedoe
            priv_quota: 250G
          - group: doefamily
            priv_quota: 500G

        smb_shares:
          - name: media
            path: /tank/media
````
