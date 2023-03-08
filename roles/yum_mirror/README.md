Yum Mirror
==========

Description
-----------

The `yum_mirror` role configures a local Yum repository that mirrors packages
from different upstream repositories.

Mirrored repositories are configured in the [vars file](vars/main.yml).


Variables
---------

This role **accepts** the following variables:

Variable                 | Default          | Description
-------------------------|------------------|------------
`yum_sync_on_calendar`   | `22,23,10,11:00` | Systemd [calendar interval](https://www.freedesktop.org/software/systemd/man/systemd.time.html#Calendar%20Events) for syncing repositories
`yum_mirrorlist_country` | `US`             | Country code for remote mirrorlists

This role **exports** the following variables:

Variable             | Description
---------------------|------------
`yum_mirror_webroot` | Path to repository directory
Usage
-----

Example playbook:

````yaml
- name: configure yum mirrors
  hosts: yum_servers
  roles:
    - role: yum_mirror
      vars:
        yum_mirrorlist_country: US

    - role: apache_vhost
      vars:
        apache_default_vhost: yes
        apache_document_root: '{{ yum_mirror_webroot }}'
        apache_autoindex: yes
        apache_redirect_to_https: no
````
