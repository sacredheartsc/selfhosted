Rspamd
======

Description
-----------

The `rspamd` role installs and configures [Rspamd](https://rspamd.com/), which
is used by [Postfix](../postfix_server/) for spam filtering and DKIM message
signing.

Variables
---------

This role **accepts** the following variables:

Variable                      | Default                         | Description
------------------------------|---------------------------------|------------
`rspamd_milter_port`          | 11332                           | Listening port for milter service
`rspamd_milter_process_count` | `{{ ansible_processor_vcpus }}` | Number of milter processes to run
`rspamd_controller_port`      | 11334                           | Listening port for controller / web GUI
`rspamd_redis_port`           | 6379                            | Local Redis port
`rspamd_redis_bayes_port`     | 6380                            | Local Redis port for Bayes classifier data
`rspamd_redis_max_memory`     | `512mb`                         | Maximum memory usage for each Redis instance
`rspamd_admin_group`          | `role-rspamd-admin`             | FreeIPA group for users allowed to access web interface (will be created)
`rspamd_dkim_keys`            | `{}`                            | Dictionary mapping domain names to DKIM signing keys
`rspamd_dkim_selector`        | `dkim`                          | Name of DKIM selector in DNS
`rspamd_domain_whitelist`     | `[]`                            | List of sender domains to _never_ mark as spam


This role **exports** the following variables:

Variable               | Description
-----------------------|------------
`rspamd_archive_shell` | Shell command to generate backup tarball of redis databases
`rspamd_apache_config` | Apache config block for reverse proxy

Usage
-----

Example playbook:

````yaml
- name: configure rspamd
  hosts: rspamd_servers
  roles:
    - role: rspamd
      vars:
        rspamd_domain_whitelist:
          - badly-configured-domain.com
          - never-mark-me-as-spam.com
        rspamd_dkim_keys:
          example.com: |
            -----BEGIN RSA PRIVATE KEY-----
            AAAAAAAAAAAAAAAAchangeme
            -----END RSA PRIVATE KEY-----
          example.net: |
            -----BEGIN RSA PRIVATE KEY-----
            AAAAAAAAAAAAAAAAchangeme
            -----END RSA PRIVATE KEY-----

    - role: apache_vhost
      vars:
        apache_default_vhost: yes
        apache_config: '{{ rspamd_apache_config }}'
````
