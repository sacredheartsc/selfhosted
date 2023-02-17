PHP
===

Description
-----------

The `php` role installs PHP and configures the PHP-FPM daemon for use with the
Apache webserver.

This role currently limited to a single PHP-FPM pool.

Variables
---------

This role **accepts** the following variables:

Variable                    | Default          | Description
----------------------------|------------------|------------
`php_post_max_size`         | `8M`             | Maximum HTTP POST size
`php_upload_max_filesize`   | `25M`            | Maximum upload filesize
`php_max_file_uploads`      | 20               | Maximum simultaneous uploads
`php_timezone`              | `{{ timezone }}` | PHP timezone
`php_fpm_user`              | `apache`         | Unix user for FPM process
`php_fpm_group`             | `apache`         | Unix group for FPM process
`php_fpm_max_children`      | 50               | Maximum number of concurrent PHP requests
`php_fpm_start_servers`     | 5                | Initial number of FPM threads
`php_fpm_min_spare_servers` | 5                | Minimum number of idle FPM threads
`php_fpm_max_spare_servers` | 35               | Maximum number of idle FPM threads
`php_fpm_flags`             | `{}`             | Dictionary of boolean PHP configuration directives
`php_fpm_admin_flags`       | `{}`             | Dictionary of boolean PHP configuration directives (non-overridable)
`php_fpm_values`            | `{}`             | Dictionary of PHP configuration directives
`php_fpm_admin_values`      | `{}`             | Dictionary of PHP configuration directives (non-overridable)
`php_fpm_environment`       | `{}`             | Dictionary of environment variables for PHP process

Usage
-----

Example playbook:

````yaml
- name: configure php
  hosts: webservers
  roles:
    - role: php
      vars:
        php_fpm_environment:
          GSS_USE_PROXY: 'yes'
        php_fpm_admin_flags:
          output_buffering: no
          always_populate_raw_post_data: no
          mbstring.func_overload: no
````
