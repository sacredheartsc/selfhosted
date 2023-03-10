Archive Server
==============

Description
-----------

The _archiver_ is my method of performing periodic backups of application data.
The general idea is that applications can write data to a dedicated directory in
`/var/spool/archive` via an [archive job](../archive_job), and the archive server
will rsync these files to a central location each night.

The `archive_server` role generates the [archiver script](templates/usr/local/bin/archiver.sh.j2),
along with a corresponding FreeIPA user account and systemd timer. The archvier
script runs daily. It iterates over each host in the `archive_clients` hostgroup
and `rsync`'s anything in `/var/spool/archive` to the location specified by
`archive_dest_path`.

Since `rsync` uses a Kerberos keytab for SSH authentication, the archiver can
only be used for hosts within the FreeIPA domain.

Archived files are sorted into subdirectories by hostname.

### Plugins

For hosts that don't support `rsync`, such as network equipment, the archiver
provides a plugin-based method of retrieving files. A plugin is just an
executable file in the [plugin directory](files/usr/local/libexec/archiver/)
that takes a target hostname as the first argument (you can also pass additional
arguments if needed).

Plugin scripts are `chdir`'d to the destination directory prior to execution,
so it's safe for them to simply write files to the current working directory.

Each line in the archiver [config file](templates/etc/archiver.conf.j2) specifies
a host to archive, along with a plugin invocation.

Currently, plugins are used to archive [OPNsense](files/usr/local/libexec/archiver/archive_opnsense)
and [EdgeSwitch](files/usr/local/libexec/archiver/archive_edgeswitch) configurations.


Variables
---------

This role **accepts** the following variables:

Variable                | Default        | Description
------------------------|----------------|------------
`archive_dest_path`     | `/nfs/archive` | Path to store archived files
`archive_user`          | `s-archiver`   | FreeIPA user account for performing SSH-based rsync
`archive_on_calendar`   | `23:00:00`     | Systemd [calendar interval](https://www.freedesktop.org/software/systemd/man/systemd.time.html#Calendar%20Events) for archiving hosts
`archive_retention_days`| 365            | Number of days to retain archive files


Usage
-----

Example playbook:

````yaml
- name: configure archive server
  hosts: archive_servers
  roles:
    - role: archive_server
      vars:
        archive_dest_path: /mnt/networkshare/archive

````
