Teddit
======

Description
-----------

The `teddit` role installs and configures [Teddit](https://codeberg.org/teddit/teddit),
an open source frontend for Reddit.

This role configures the NodeJS application only; it does not configure a reverse
proxy.


Variables
---------

This role **accepts** the following variables:

Variable                         | Default              | Description
---------------------------------|----------------------|------------
`teddit_version`                 | `main`               | Git version to install
`teddit_port`                    | 8080                 | Local listening port
`teddit_server_name`             | `{{ ansible_fqdn }}` | Canonical HTTP hostname
`teddit_update_on_calendar`      | `weekly`             | Systemd [calendar interval](https://www.freedesktop.org/software/systemd/man/systemd.time.html#Calendar%20Events) for updating teddit
`teddit_use_reddit_oauth`        | no                   | Use OAuth for Reddit API
`teddit_reddit_app_id`           | &nbsp;               | Reddit app ID for OAuth
`teddit_theme`                   | `auto`               | Either `dark`, `sepia`, or `auto`
`teddit_clean_homepage`          | yes                  | Use clean homepage
`teddit_flairs_enabled`          | no                   | Show Reddit flairs
`teddit_highlight_controversial` | yes                  | Highlight controversial comments
`teddit_videos_muted`            | yes                  | Automatically mute videos
`teddit_comments_sort`           | `confidence`         | Either `confidence`, `top`, `new`, `controversial`, `old`, `random`
`teddit_show_upvotes`            | yes                  | Show upvote counts
`teddit_show_upvote_percentage`  | yes                  | Show upvote percentages
`teddit_suggested_subreddits`    | `['All', 'Saved']`   | List of suggested subreddits
`teddit_redis_port`              | 6379                 | Local Redis port
`teddit_cache_control_interval`  | 24                   | How often to purge static file cache (hours)


This role **exports** the following variables:

Variable               | Description
-----------------------|------------
`teddit_apache_config` | Apache config block to configure a reverse proxy


Usage
-----

Example playbook:

````yaml
- name: configure teddit web application
  hosts: privbrowse_servers
  roles:
    - role: teddit
      vars:
        teddit_server_name: teddit.ipa.example.com
        teddit_use_reddit_oauth: no

    - role: apache_vhost
      vars:
        apache_server_name: '{{ teddit_server_name }}'
        apache_server_aliases: []
        apache_config: '{{ teddit_apache_config }}'
````
