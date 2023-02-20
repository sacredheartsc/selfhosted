Rsyslog Server
==============

Description
-----------

The `rsyslog_server` role configures Rsyslog to log messages from other client
hosts. Log files are stored in paths of the following format:
`/var/log/remote/YYYY/MM/DD/$HOSTNAME`

Variables
---------

This role **accepts** the following variables:

Variable                   | Default              | Description
---------------------------|----------------------|------------
`rsyslog_owner`            | `root`               | Unix owner of log files
`rsyslog_group`            | `root`               | Unix group owner of log files
`rsyslog_file_mode`        | `0640`               | Permission mode of log files
`rsyslog_dir_mode`         | `0750`               | Permission mode of log directories
`rsyslog_port`             | 514                  | Syslog listening port
`rsyslog_relp_port`        | 20514                | RELP listening port
`rsyslog_relp_tls_port`    | 10514                | TLS RELP listening port
`rsyslog_gzip_on_calendar` | `daily`              | Systemd [calendar interval](https://www.freedesktop.org/software/systemd/man/systemd.time.html#Calendar%20Events) to gzip log files
`rsyslog_gzip_days_ago`    | 7                    | Days to keep text logs before compressing
`rsyslog_permitted_peers`  | `['*.{{ domain }}']` | List of TLS client name patterns to accept


Usage
-----

Example playbook:

````yaml
- name: configure syslog servers
  hosts: syslog_servers
  roles:
    - role: rsyslog_server
      vars:
        rsyslog_owner: root
        rsyslog_group: sysadmins
        rsyslog_gzip_days_ago: 7
````
