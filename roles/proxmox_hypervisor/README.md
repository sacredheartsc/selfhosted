Proxmox Hypervisor
==================

Description
-----------

The `proxmox_hypervisor` role prepares a Proxmox server to run Rocky Linux
virtual machines via the [proxmox\_instance](../proxmox_instance/) role.

This role is rather large, because it also performs the all the base
configuration that is otherwise performed by the [common](../common/)
role. This does result in some Ansible duplication--but since the Proxmox server
is the only non-Rocky-Linux host in my network, I didn't want to convolute all
the other roles with distro-specific branching.

VM templates are generated from the image URLs listed in the [vars file](vars/main.yml).

I would recommend against setting the FreeIPA DNS servers in `resolv.conf` on
the Proxmox host. If your VM is down, you'll lose DNS resolution on the
hypervisor.


Variables
---------

This role **accepts** the following variables:

Variable                          | Default                   | Description
----------------------------------|---------------------------|------------
`proxmox_api_user`                | `ansible`                 | Proxmox API user (will be created)
`proxmox_api_password`            | &nbsp;                    | Proxmox API pasword
`proxmox_ntp_servers`             | `{{ vlan.ntp_servers }}`  | NTP servers
`proxmox_postfix_myorigin`        | `{{ email_domain }}`      | Default sender domain (see [documentation](https://www.postfix.org/postconf.5.html#myorigin))
`proxmox_postfix_relayhost`       | `{{ email_domain }}`      | Next-hop destination for mail delivery (see [documentation](https://www.postfix.org/postconf.5.html#relayhost))
`proxmox_syslog_host`             | `{{ syslog_host_ip }}`    | Syslog target IP
`proxmox_syslog_port`             | 514                       | Syslog target port
`proxmox_syslog_proto`            | `tcp`                     | Syslog transport protocol
`proxmox_sudo_mailto`             | `root`                    | Email address for sudo logging
`proxmox_bridge`                  | `vmbr0`                   | Template VM bridge interface
`proxmox_storage`                 | `local-zfs`               | Template VM storage name
`proxmox_zfs_trim_on_calendar`    | `monthly`                 | Systemd [calendar interval](https://www.freedesktop.org/software/systemd/man/systemd.time.html#Calendar%20Events) for ZFS SSD trim
`proxmox_zfs_scrub_on_calendar`   | `monthly`                 | Systemd [calendar interval](https://www.freedesktop.org/software/systemd/man/systemd.time.html#Calendar%20Events) for ZFS scrub
`proxmox_zed_email`               | `root`                    | Destination em
`proxmox_zed_verbose`             | yes                       | Email address for ZFS Event Daemon (ZED) alerts
`proxmox_zed_notify_interval_sec` | 3600                      | Notification interval for ZED alerts (seconds)
`proxmox_nagios_ssh_pubkey`       | `{{ nagios_ssh_pubkey }}` | Nagios SSH public key
`proxmox_snmp_location`           | `unknown`                 | SNMP location string
`proxmox_snmp_contact`            | `root@{{ email_domain }}` | SNMP contact
`proxmox_snmp_v3_users`           | `nagios` snmp user        | SNMPv3 user list (see [format](#proxmox_snmp_v3_users) below)


### proxmox\_snmp\_users

The `proxmox_snmp_v3_users` variable lists the SNMPv3 user accounts for the
host. It should contain a list of dictionaries of the following format:

Key          | Default | Description
-------------|---------|------------
`name`       | &nbsp;  | SNMPv3 user name
`auth_pass`  | &nbsp;  | SNMPv3 authentication password
`priv_pass`  | &nbsp;  | SNMPv3 privacy password


Usage
-----

Example playbook:

````yaml
- name: set up proxmox servers
  hosts: proxmox_hypervisors
  roles:
    - role: proxmox_hypervisor
      vars:
        proxmox_api_user: ansible
        proxmox_api_password: s3cret
````
