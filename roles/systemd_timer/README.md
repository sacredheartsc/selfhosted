Systemd Timer
=============

Description
-----------

The `systemd_timer` role creates a systemd timer to run a specified command.
The command can either be passed directly to `exec`, or be run within the shell.


Variables
---------

This role **accepts** the following variables:

Variable            | Default                        | Description
--------------------|--------------------------------|------------
`timer_name`        | &nbsp;                         | Name of systemd unit
`timer_description` | `name` of timer                | Description of systemd unit
`timer_enabled`     | yes                            | Enable the timer unit
`timer_after`       | &nbsp;                         | Systemd units to run before timer (space-separated or list, see [documentation](https://www.freedesktop.org/software/systemd/man/systemd.unit.html#Before=))
`timer_persistent`  | yes                            | Persist timer across reboots (see [documentation](https://www.freedesktop.org/software/systemd/man/systemd.timer.html#Persistent=))
`timer_user`        | `root`                         | Unix user that executes the command
`timer_group`       | &nbsp;                         | Unix group that executes the command
`timer_chdir`       | &nbsp;                         | Systemd `WorkingDirectory` (see [documentation](https://www.freedesktop.org/software/systemd/man/systemd.exec.html#WorkingDirectory=))
`timer_exec`        | &nbsp;                         | Command to run
`timer_shell`       | no                             | Run command within a shell


Usage
-----

Example task:

````yaml
- name: create timer to update invidious
  include_role:
    name: systemd_timer
  vars:
    timer_name: invidious-update
    timer_description: Update invidious
    timer_after: network.target
    timer_on_calendar: weekly
    timer_exec: /opt/invidious/invidious-update.sh
````
