Linux Desktop
=============

Description
-----------

The `linux_desktop` role performs various setup tasks for Linux workstations,
including:

  - install and configure GNOME desktop environment
  - set the default systemd target to `graphical`
  - configure Flatpak repository and install apps

Lists of Yum and Flatpak applications to be installed can be found in the
[vars file](vars/main.yml).

Variables
---------

This role **accepts** the following variables:

Variable                                   | Default                     | Description
-------------------------------------------|-----------------------------|------------
`linux_desktop_access_group`               | `role-linux-desktop-access` | FreeIPA group allowed to login to GDM (will be created)
`linux_desktop_flatpak_update_on_calendar` | `daily`                     | Systemd [calendar interval](https://www.freedesktop.org/software/systemd/man/systemd.time.html#Calendar%20Events) for updating Flatpak apps
`linux_desktop_enable_wayland`             | yes                         | Enable Wayland compositor
`linux_desktop_thumbnail_cache_size`       | 4096                        | Size of thumbnail cache (MB)
`linux_desktop_enable_window_buttons`      | yes                         | Enable minimize and maximize buttons

Usage
-----

Example playbook:

````yaml
- name: configure gnome desktop
  hosts: linux_desktops
  roles:
    - role: linux_desktop
      vars:
        linux_desktop_enable_window_buttons: yes
````
