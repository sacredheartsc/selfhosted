Nagios Server
=============

Description
-----------

The `nagios_server` role installs and configures the [Nagios](https://www.nagios.org/)
monitoring system. The check configuration is generated from the Ansible inventory
using various `nagios_`-prefixed host variables.

This role does not install a webserver; it configures the Nagios application only.

The config file templates are tightly coupled to the group names in the [example inventory](../../inventory-example/).
If you change the group names, then you'll also need to modify the [object templates](templates/etc/nagios/objects/).

### Why Nagios?

I admit, Nagios is long in the tooth, and the interface leaves much to be
desired. In my view, it has three major advantages:

  - You can just `dnf install nagios`, and you're ready to go. No supporting
    infrastructure required.

  - The configuration syntax is extremely simple, making it easy to
    automatically generate the config files.

  - Extending it with your own plugins is trivial: you just write a script that
    returns `0`, `1`, or `2`.

You _can_ use Nagios for metrics gathering, but its not well-suited to the task.
In this project, its used purely for health checks.

I would have preferred to use [Icinga](https://icinga.com/) for its slick
interface, but they sadly put RPM packages behind a paywall recently.


Variables
---------

This role **accepts** the following variables:

Variable                              | Default                   | Description
--------------------------------------|---------------------------|------------
`nagios_admin_email`                  | `root@{{ email_domain }}` | Administrator's email address
`nagios_admin_pager`                  | `root@{{ email_domain }}` | Administrator's "pager" (not really used)
`nagios_access_group`                 | `role-nagios-access`      | FreeIPA group of users allowed to access web interface (will be created)
`nagios_email`                        | `root@{{ email_domain }}` | Default contact email for alerts
`nagios_reboot_window`                | `03:00-05:00`             | Daily [Time Period](https://assets.nagios.com/downloads/nagioscore/docs/nagioscore/3/en/objectdefinitions.html#timeperiod) for host reboots
`nagios_ssh_privkey`                  | &nbsp;                    | SSH private key for `nagios` user
`nagios_excluded_groups`              | `[]`                      | List of Ansible group names to exclude from checks
`nagios_ssh_control_persist`          | `20m`                     | Timeout of persistent SSH connection
`nagios_snmp_max_size`                | 10000                     | Maximum size of SNMP responses (bytes)
`nagios_manubulon_version`            | `master`                  | Git version of [Manubulon](https://github.com/SteScho/manubulon-snmp) to install
`nagios_check_dns`                    | `[]`                      | DNS checks to perform (see [format](#nagios_check_dns) below)
`nagios_connectivity_check_host`      | `8.8.8.8`                 | Host to use for upstream connectivity check
`nagios_connectivity_check_count`     | 20                        | Number of ICMP packets to use for connectivity check
`nagios_connectivity_check_rtt_warn`  | 50.0                      | Round-trip-time warning threshold for connectivity check (ms)
`nagios_connectivity_check_rtt_crit`  | 100.0                     | Round-trip-time critical threshold for connectivity check (ms)
`nagios_connectivity_check_loss_warn` | `5%`                      | Packet loss warning threshold for connectivity check
`nagios_connectivity_check_loss_crit` | `20%`                     | Packet loss critical threshold for connectivity check


### nagios\_check\_dns

The `nagios_check_dns` variable lists DNS checks to perform. It should contain
a list of dictionaries of the following format:

Variable | Default | Description
---------|---------|------------
name     | &nbsp;  | FQDN to query
qtype    | `A`     | Query type
server   | &nbsp;  | Upstream DNS server to query
expect   | &nbsp;  | Expected response


### Exports

This role **exports** the following variables:

Variable               | Description
-----------------------|------------
`nagios_html_dir`      | Nagios webroot path
`nagios_apache_config` | Apache config block for Nagios CGI application


Host Variables
--------------

In addition to variables for the `nagios_server` role itself, you can set various
`nagios_`-prefixed hostvars to influence the check behavior for each host.
Defaults for these host-specific variables are set in [group\_vars/all/nagios.yml](../../inventory-example/group_vars/all/nagios.yml)
in the example inventory.

Variable                          | Description
----------------------------------|------------
`nagios_snmp_user`                | SNMPv3 username
`nagios_snmp_community`           | SNMP community string
`nagios_snmp_auth_proto`          | SNMPv3 authentication protocol
`nagios_snmp_priv_proto`          | SNMPv3 encryption protocol
`nagios_snmp_auth_pass`           | SNMPv3 authentication password
`nagios_snmp_priv_pass`           | SNMPv3 encryption password
`nagios_ping_count`               | ICMP packet count for `hostalive` check
`nagios_ping_rtt_warn`            | Round-trip time warning threshold for `hostalive` check
`nagios_ping_rtt_crit`            | Round-trip time critical threshold for `hostalive` check
`nagios_ping_loss_warn`           | Packet loss warning threshold for `hostalive` check
`nagios_ping_loss_crit`           | Packet loss critical threshold for `hostalive` check
`nagios_temp_warn`                | Temperature warning threshold (C)
`nagios_temp_crit`                | Temperature critical threshold (C)
`nagios_power_draw_warn`          | Power draw warning threshold (%)
`nagios_power_draw_crit`          | Power draw critical threshold (%)
`nagios_load_1m_warn`             | 1m load average (warn)
`nagios_load_5m_warn`             | 5m load average (warn)
`nagios_load_15m_warn`            | 15m load average (warn)
`nagios_load_1m_crit`             | 1m load average (crit)
`nagios_load_5m_crit`             | 5m load average (crit)
`nagios_load_15m_crit`            | 15m load average (crit)
`nagios_mem_warn`                 | Memory usage warning threshold (%)
`nagios_mem_crit`                 | Memory usage critical threshold (%)
`nagios_swap_warn`                | Swap usage warning threshold (%)
`nagios_swap_crit`                | Swap usage critical threshold (%)
`nagios_interface_bandwidth_warn` | Interface bandwith warning threshold (Mbps)
`nagios_interface_bandwidth_crit` | Interface bandwith critical threshold (Mbps)
`nagios_interface_discard_warn`   | Interface discards warning threshold (per second)
`nagios_interface_discard_crit`   | Interface discards critical threshold (per second)
`nagios_interface_error_warn`     | Interface errors warning threshold (per second)
`nagios_interface_error_crit`     | Interface errors critical threshold (per second)
`nagios_interfaces`               | Per-interface threshold overrides (see [format](#nagios_interfaces) below)
`nagios_disk_warn`                | Disk usage warning threshold (%)
`nagios_disk_crit`                | Disk usage critical threshold (%)
`nagios_disks`                    | Per-filesystem threshold overrides (see [format](#nagios_disks) below)
`nagios_certificate_warn`         | Certificate validity days remaining (warning)
`nagios_certificate_crit`         | Certificate validity days remaining (critical)
`nagios_smtp_warn`                | SMTP response time warning threshold (seconds)
`nagios_smtp_crit`                | SMTP response time critical threshold (seconds)
`nagios_mailq_warn`               | Mail queue warning size
`nagios_mailq_crit`               | Mail queue critical size
`nagios_imap_warn`                | IMAP response time warning threshold (seconds)
`nagios_imap_crit`                | IMAP response time warning threshold (seconds)
`nagios_http_warn`                | HTTP response time warning threshold (seconds)
`nagios_http_crit`                | HTTP response time warning threshold (seconds)


### nagios\_interfaces

The `nagios_interfaces` variable is used to specify check thresholds for each
network interface independently. It should contain a list of dictionaries of
the following format:

Variable         | Default                                 | Description
-----------------|-----------------------------------------|-----------
`name`           | &nbsp;                                  | Interface name
`regex`          | &nbsp;                                  | Regular expression matching one or more interfaces
`description`    | `interface name`                        | Nagios check name
`down_ok`        | no                                      | Don't alert when interface is down
`bandwidth_warn` | `{{ nagios_interface_bandwidth_warn }}` | Bandwidth warning threshold (Mbps)
`bandwidth_crit` | `{{ nagios_interface_bandwidth_crit }}` | Bandwidth critical threshold (Mbps)
`discard_warn`   | `{{ nagios_interface_discard_warn }}`   | Discard warning threshold (per second)
`discard_crit`   | `{{ nagios_interface_discard_crit }}`   | Discard critical threshold (per second)
`error_warn`     | `{{ nagios_interface_error_warn }}`     | Error warning threshold (per second)
`error_crit`     | `{{ nagios_interface_error_crit }}`     | Error critical threshold (per second)

The `nagios_interfaces` variable can also contain a simple list of interface
names, in which case the default check thresholds will be used.


### nagios\_disks

The `nagios_disks` variable is used to specify check thresholds for each
filesystem independently. It should contain a list of dictionaries of
the following format:

Variable      | Default                  | Description
--------------|--------------------------|------------
`path`        | &nbsp;                   | Path of the disk's mountpoint
`regex`       | &nbsp;                   | Regular expression matching one or more mountpoints
`description` | `mount path`             | Nagios check name
`exclude`     | no                       | Treat mountpoint as exclusion pattern
`terse`       | no                       | Use shorter check output
`warn`        | `{{ nagios_disk_warn }}` | Disk usage warning threshold (%)
`crit`        | `{{ nagios_disk_crit }}` | Disk usage critical threshold (%)

The `nagios_disks` variable can also contain a simple list of mountpoints, in
which case the default check thresholds will be used.


Usage
-----

Example playbook:

````yaml
- hosts: nagios_servers
  roles:
    - role: nagios_server
      vars:
        nagios_check_dns:
          - name: example.com
            qtype: A
            server: 8.8.8.8
            expect: 1.2.3.4

    - role: apache_vhost
      vars:
        apache_document_root: '{{ nagios_html_dir }}'
        apache_config: '{{ nagios_apache_config }}'
````
