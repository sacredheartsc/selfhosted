Archive Job
===========

Description
-----------

The _archiver_ is my method of performing periodic backups of application data.
The general idea is that applications can write data to a dedicated directory in
`/var/spool/archive`, and the [archive\_server](../archive_server) will rsync any
of these files to a central location each night.

The `archive_job` role creates a systemd timer to perform an application's archive
job at a given calendar interval. The archive command can be specified as an
`argv` to pass to exec, or as a string to be interpreted by the shell.

Archive commands are `chdir`ed to the appropriate spool directory prior to
execution, so it's safe to to just write to the current working directory.


Variables
---------

This role **accepts** the following variables:

Variable              | Default                      | Description
----------------------|------------------------------|------------
`archive_name`        | &nbsp;                       | Name of the archive job
`archive_description` | `archive {{ archive_name }}` | Description of the archive job
`archive_user`        | root                         | Unix user that executes the job process
`archive_group`       | `{{ archive_user }}`         | Unix group that executes the job process
`archive_command`     | &nbsp;                       | Command to execute (will be passed as-is to `exec`)
`archive_shell`       | &nbsp;                       | Shell command to execute
`archive_on_calendar` | weekly                       | Systemd [calendar interval](https://www.freedesktop.org/software/systemd/man/systemd.time.html#Calendar%20Events) for running archive job


Usage
-----

Example playbook:

````yaml
- name: configure cups archive job
  hosts: cups_servers
  roles:
    - role: archive_job
      archive_name: cups
      archive_shell: >-
        TIMESTAMP=$(date +%Y%m%d%H%M%S);
        tar czf "cups-${TIMESTAMP}.tar.gz"
        --transform "s|^\.|cups-${TIMESTAMP}|"
        -C /etc/cups
        ./ppd ./printers.conf
      tags: archive
````
