Invidious
=========

Description
-----------

The `invidious` role builds and configures the [Invidious](https://invidious.io/)
YouTube frontend. It also installs a script to automatically update Invidious
periodically.

This role configures the application only; it does not configure a reverse
proxy.

Invidious uses PostgreSQL, but since it does not use `libpq`, it does not
support GSSAPI authentication. Hence why the `invidious_db_password` variable
is required.

Variables
---------

This role **accepts** the following variables:

Variable                              | Default                               | Description
--------------------------------------|---------------------------------------|------------
`invidious_version`                   | `master`                              | Git version to build
`invidious_crystal_version`           | see [default vars](defaults/main.yml) | Crystal version to install
`invidious_server_name`               | `{{ ansible_fqdn }}`                  | Canonical HTTP hostname
`invidious_port`                      | 8080                                  | Local listening port
`invidious_db_user`                   | `s-invidious`                         | Database user (will be created)
`invidious_db_password`               | &nbsp;                                | Database password
`invidious_db_name`                   | `invidious`                           | Database name (will be created)
`invidious_db_host`                   | `{{ postgresql_host }}`               | PostgreSQL host
`invidious_db_cleanup_on_calendar`    | `weekly`                              | Systemd [calendar interval](https://www.freedesktop.org/software/systemd/man/systemd.time.html#Calendar%20Events) for pruning database
`invidious_update_on_calendar`        | `weekly`                              | Systemd [calendar interval](https://www.freedesktop.org/software/systemd/man/systemd.time.html#Calendar%20Events) for updating Invidious
`invidious_channel_threads`           | 1                                     | Number of threads to use when updating channels
`invidious_feed_threads`              | 1                                     | Number of threads to use when updating RSS feeds
`invidious_registration_enabled`      | yes                                   | Enable new user registration
`invidious_popular_enabled`           | no                                    | Enable "Popular" page for this instance
`invidious_full_refresh`              | no                                    | Forcefully re-download entire channel when updating
`invidious_use_pubsub_feeds`          | no                                    | Subscribe to channel updates via PubSub (instance must be publicly reachable)
`invidious_hmac_key`                  | &nbsp;                                | PubSub HMAC key
`invidious_default_locale`            | `en-US`                               | Default locale
`invidious_default_region`            | `US`                                  | Default region
`invidious_default_dark_mode`         | `auto`                                | Default dark mode setting (either `dark`, `light`, or `auto`)
`invidious_default_autoplay`          | no                                    | Autoplay videos by default
`invidious_default_continue`          | yes                                   | Load next video by default
`invidious_default_continue_autoplay` | no                                    | Autoplay next video by default
`invidious_default_local`             | yes                                   | Proxy videos through instance by default
`invidious_default_quality`           | `dash`                                | Default video quality (either `dash`, `hd720`, `medium`, or `small`)
`invidious_default_quality_dash`      | `1080p`                               | Default `dash` video quality (either `auto`, `best`, `worst`, `1440p`, `1080p`, etc)
`invidious_default_related_videos`    | yes                                   | Show related videos by default
`invidious_default_video_loop`        | no                                    | Loop videos by default
`invidious_default_player_style`      | `invidious`                           | Default player style (either `invidious` or `youtube`)
`invidious_default_home`              | `Subscriptions`                       | Default home page (either `Popular`, `Trending`, `Subscriptions`, or `Playlists`)
`invidious_feed_menu`                 | `['Subscriptions', 'Playlists']`      | Feeds to show on the home page (choose from `Popular`, `Trending`, `Subscriptions`, and `Playlists`)


This role **exports** the following variables:

Variable                  | Description
--------------------------|------------
`invidious_apache_config` | Apache config block for reverse proxy

Usage
-----

Example playbook:

````yaml
- hosts: invidious_servers
  roles:
    - role: invidious
      vars:
        invidious_db_host: postgres.ipa.example.com
        invidious_db_password: s3cret
        invidious_default_local: no
        invidious_server_name: invidious.ipa.example.com

    - role: apache_vhost
      vars:
        apache_server_name: '{{ invidious_server_name }}'
        apache_server_aliases: []
        apache_config: '{{ invidious_apache_config }}'
````
