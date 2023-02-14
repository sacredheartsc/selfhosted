Journald
========

Description
-----------

The `journald` role configures the systemd journal.

Variables
---------

This role **accepts** the following variables:

Variable                     | Default | Description
-----------------------------|---------|------------
`journald_persistent`        | no      | Persist journal to disk
`journald_forward_to_syslog` | yes     | Forward journal messages to syslog socket
`journald_max_use`           | &nbsp;  | Set [maximum journal size](https://www.freedesktop.org/software/systemd/man/journald.conf.html#SystemMaxUse=)


Usage
-----

Example playbook:

````yaml
- hosts: all
  roles:
    - role: journald
      vars:
        journald_persistent: no
        journald_forward_to_syslog: yes
````
