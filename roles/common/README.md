Common
======

Description
-----------

The `common` role is a meta-role that performs base configuration common to all
Rocky Linux hosts.

This role pulls in the following roles as dependencies:


Role                                                          | Description 
--------------------------------------------------------------|-------------
[proxmox\_instance](../proxmox_instance/)                     | Builds a Proxmox VM if host is a member of `proxmox_instances`
[dns\_records](../dns_records/)                               | Creates A, PTR, and CNAME records for the host in FreeIPA
[gather\_facts](../gather_facts/)                             | Runs the Ansible `setup` module once the host is reachable.
[udev](../udev/)                                              | Configures `udev` rules
[root\_authorized\_keys](../root_authorized_keys/)            | Sets `authorized_keys` for the root user
[root\_password](../root_password/)                           | Sets password for the root user
[polkit](../polkit/)                                          | Adds a `polkit` rule for the specified admin group
[grub](../grub/)                                              | Configures kernel command line in `grub` 
[sudo](../sudo/)                                              | Configures `sudo`
[hostname](../hostname/)                                      | Sets the hostname
[timezone](../timezone/)                                      | Sets the timezone
[journald](../journald/)                                      | Configures systemd journal
[yum\_disable\_default\_repos](../yum_disable_default_repos/) | Disables upstream Rocky Linux yum repos
[yum](../yum/)                                                | Configures internal yum repos
[dnsmasq](../dnsmasq/)                                        | Configures `dnsmasq` for local DNS caching
[locale](../locale/)                                          | Sets the locale
[selinux](../selinux/)                                        | Enables SELinux and `setroubleshootd`
[qemu\_guest\_agent](../qemu_guest_agent/)                    | Enables `qemu-guest-agent` for Proxmox VMs
[firewalld](../firewalld/)                                    | Enables local firewall with `firewalld`
[chrony](../chrony/)                                          | Enables `chrony` NTP client
[dnf\_automatic](../dnf_automatic/)                           | Configures automatic package updates and reboots
[ssh](../ssh/)                                                | Generates global `ssh_config`
[tuned](../tuned/)                                            | Configures `tuned` profile
[motd](../motd/)                                              | Disables `cockpit` MOTD message
[packages](../packages/)                                      | Installs common packages
[postfix\_client](../postfix_client/)                         | Configures `postfix` client for internal mailserver
[freeipa\_client](../freeipa_client/)                         | Joins host to FreeIPA domain
[rsyslog\_client](../rsyslog_client/)                         | Configures `rsyslog` forwarding to internal syslog server
[nagios\_client](../nagios_client/)                           | Configures `nagios` user and plugin scripts

Usage
-----

Example playbook:

````yaml
- name: apply base configuration
  hosts: all
  roles:
    - common
````
