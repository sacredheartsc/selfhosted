Linux Laptop
============

Description
-----------

The `linux_laptop` role performs various setup tasks for Linux laptops,
such as configuring power-saving tuneables and creating a WiFi connection
using certificate-based authentication.

For WiFi authentication to work, you'll need a RADIUS server configured with
the [freeradius](../freeradius/) role.

Variables
---------

This role **accepts** the following variables:

Variable                                 | Default                     | Description
-----------------------------------------|-----------------------------|------------
`linux_laptop_access_group`              | `role-linux-desktop-access` | FreeIPA group allowed to login to GDM (will be created)
`linux_laptop_wifi_ssid`                 | &nbsp;                      | SSID of local WiFi network
`linux_laptop_wifi_ip`                   | `{{ ip }}`                  | Static IPv4 address for WiFi connection
`linux_laptop_wifi_prefix`               | `{{ vlan.cidr }}` prefix    | Network prefix for WiFi connection
`linux_laptop_wifi_gateway`              | `{{ vlan.gateway }}`        | Gateway for WiFi connection
`linux_laptop_wifi_domain`               | `{{ domain }}`              | Default DNS domain for WiFi connection
`linux_laptop_wifi_dns_servers`          | `{{ vlan.dns_servers }}`    | DNS serers for WiFi connection
`linux_laptop_wlan_device`               | `wlan0`                     | Wireless network interface name
`linux_laptop_dirty_writeback_centisecs` | 6000                        | [Disk writeback interval](https://www.kernel.org/doc/html/latest/admin-guide/sysctl/vm.html#dirty-writeback-centisecs)

Usage
-----

Example playbook:

````yaml
- name: perform laptop setup tasks
  hosts: linux_laptops
  roles:
    - role: linux_laptop
      vars:
        linux_laptop_access_group: laptop-users
        linux_laptop_wifi_ssid: exampleorg-wifi
````
