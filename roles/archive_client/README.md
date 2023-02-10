Archive Client
==============

Description
-----------

The _archiver_ is my method of performing periodic backups of application data.
The general idea is that applications can write data to a dedicated directory in
`/var/spool/archive` via an [archive job](../archive_job), and the [archive server](../archive_server)
will rsync these files to a central location each night.

The `archive_client` role prepares a host to perform [archive jobs](../archive_job).
It adds the host to the `archive_clients` hostgroup and prepares the archive spool
directory.


Variables
---------

This role **accepts** the following variables:

Variable                          | Default    | Description
----------------------------------|------------|------------
`archive_server_user`             | s-archiver | Username of the [archive server](../archive_server) user
`archive_cleanup_on_calendar`     | daily      | Systemd [calendar interval](https://www.freedesktop.org/software/systemd/man/systemd.time.html#Calendar%20Events) for deleting old archive files
`archive_cleanup_older_than_days` | 7          | Maximum age of files to retain in the archive spool (days)


Usage
-----

You should not need to call this role directly. It is a dependency of the
[archive\_job](../archive_job) role.
