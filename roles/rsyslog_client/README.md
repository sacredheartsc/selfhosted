Rsyslog Client
==============

Description
-----------

The `rsyslog_client` role configures Rsyslog to forward local syslog messages
to a central syslog server.

Variables
---------

This role **accepts** the following variables:

Variable                       | Default             | Description
-------------------------------|---------------------|------------
`rsyslog_forward`              | yes                 | Forward syslog messages to remote server
`rsyslog_tls`                  | yes                 | Use TLS encryption
`rsyslog_target`               | `{{ syslog_host }}` | Hostname of syslog server
`rsyslog_relp_port`            | 20514               | Destination port for RELP messages
`rsyslog_relp_tls_port`        | 10514               | Destination TLS port for RELP messages
`rsyslog_queue_max_disk_space` | `250m`              | Maximum disk space to use for message queue
`rsyslog_queue_size`           | 10000               | Maximum number of messages to keep in message queue


Usage
-----

Example playbook:

````yaml
- name: configure syslog forwarding
  hosts: all
  roles:
    - role: rsyslog_client
      vars:
        rsyslog_target: syslog.ipa.example.com
        rsyslog_forward: yes
        rsyslog_tls: yes
````
