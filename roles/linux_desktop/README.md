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

Variable                                   | Default                           | Description
-------------------------------------------|-----------------------------------|------------
`linux_desktop_access_group`               | `role-linux-desktop-access`       | FreeIPA group allowed to login to GDM (will be created)
`linux_desktop_flatpak_update_on_calendar` | `daily`                           | Systemd [calendar interval](https://www.freedesktop.org/software/systemd/man/systemd.time.html#Calendar%20Events) for updating Flatpak apps
`linux_desktop_enable_wayland`             | yes                               | Enable Wayland compositor
`linux_desktop_thumbnail_cache_size`       | 4096                              | Size of thumbnail cache (MB)
`linux_desktop_display_manager`            | `gdm`                             | Either `gdm` or `lightdm`
`linux_desktop_qogir_version`              | see [defaults](defaults/main.yml) | [Qogir theme](https://github.com/vinceliuice/Qogir-theme) version
`linux_desktop_qogir_icon_version`         | see [defaults](defaults/main.yml) | [Qogir icon theme](https://github.com/vinceliuice/Qogir-icon-theme) version
`linux_desktop_lightdm_gtk_theme`          | `Qogir`                           | LightDM GTK theme name
`linux_desktop_lightdm_icon_theme`         | `Qogir`                           | LightDM icon theme name
`linux_desktop_lightdm_cursor_theme`       | `Qogir`                           | LightDM cursor theme name

Usage
-----

Example playbook:

````yaml
- name: configure gnome desktop
  hosts: linux_desktops
  roles:
    - role: linux_desktop
````
