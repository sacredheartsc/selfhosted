dnf-automatic
=============

Description
-----------

The `dnf_automatic` role configures the [dnf-automatic](https://dnf.readthedocs.io/en/latest/automatic.html)
systemd timer to automatically update system packages.

In addition, it provides a custom [post-update script](files/usr/local/sbin/dnf-auto-restart)
which automatically restarts any systemd units affected by the update and
reboots the host (when necessary).


Variables
---------

This role **accepts** the following variables:

Variable                     | Default   | Description
-----------------------------|-----------|------------
`dnf_automatic_on_calendar`  | `03:00`   | Systemd [calendar interval](https://www.freedesktop.org/software/systemd/man/systemd.time.html#Calendar%20Events) for performing updates
`dnf_automatic_random_delay` | `60m`     | [Randomized delay](https://www.freedesktop.org/software/systemd/man/systemd.timer.html#RandomizedDelaySec=) for update timer
`dnf_automatic_restart`      | yes       | Enable automatic reboot and service restarts

Usage
-----

Example playbook:

````yaml
- name: configure automatic package updates
  hosts: all
  roles:
    - role: dnf_automatic
      vars:
        dnf_automatic_on_calendar: 06:00
        dnf_automatic_restart: yes
````
