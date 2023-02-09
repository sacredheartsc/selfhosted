Archive Server
==============

Description
-----------

The _archiver_ is my method of performing periodic backups of application data.
The general idea is that applications can write data to a dedicated directory in
`/var/spool/archive`, and the archive server will rsync these files to a central
location each night.

The `archive_server` role generates the _archiver_ script, along with a
corresponding FreeIPA user account and systemd timer. The [archvier script](templates/usr/local/bin/archiver.sh.j2)
runs daily. It iterates over each host in the `archive_clients` hostgroup
and `rsync`s any archive files to a subdirectory `archive_dest_path`, organized
by hostname.

### Plugins

For hosts that don't support rsync, such as network equipment, the _archiver_
provides a plugin-based method of downloading files. Plugins consist of
executable files in the [plugin directory](files/usr/local/libexec/archiver/)
that take a target hostname as the first argument (you can also pass additional
arguments if needed).

Each line in the archiver [config file](templates/etc/archiver.conf.j2) specifies
a host to archive, along with a plugin invocation.

Currently, plugins are used to archive [OPNsense](files/usr/local/libexec/archiver/archive_opnsense)
and [EdgeSwitch](files/usr/local/libexec/archiver/archive_edgeswitch) configuration.

Variables
---------

This role **accepts** the following variables:

Variable                | Default      | Description
------------------------|--------------|------------
`archive_dest_path`     | /nfs/archive | Path to store archive files
`archive_user`          | s-archiver   | FreeIPA user account to perform SSH-based rsync (keytab will be retrieved)
`archive_on_calendar`   | 23:00:00     | Systemd [calendar interval](https://www.freedesktop.org/software/systemd/man/systemd.time.html#Calendar%20Events) for archiving hosts
`archive_retention_days`| 365          | Number of days to retain archive files


Usage
-----

Example playbook:

````yaml
- name: configure archive server
  hosts: archive_servers
  roles:
    - archive_server
````
