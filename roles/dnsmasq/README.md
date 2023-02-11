dnsmasq
=======

Description
-----------

The `dnsmasq` role configures NetworkManager to use [dnsmasq](https://thekelleys.org.uk/dnsmasq/doc.html)
for local DNS caching.


Variables
---------

This role **accepts** the following variables:

Variable                 | Default                  | Description
-------------------------|--------------------------|------------
`dnsmasq_nameservers`    | `{{ vlan.dns_servers }}` | Upstream DNS servers
`dnsmasq_searchdomain`   | `{{ domain }}`           | Default search domain
`dnsmasq_resolv_options` | `['rotate']`             | List of `resolv.conf(5)` options
`dnsmasq_cache_size`     | 1000                     | Number of records to cache
`dnsmasq_negcache`       | no                       | Enable caching of `NXDOMAIN` responses
`dnsmasq_all_servers`    | yes                      | Query all nameservers simultaneously (first response wins)


Usage
-----

Example playbook:

````yaml
- name: configure local DNS caching
  hosts: all
  roles:
    - role: dnsmasq
      vars:
        dnsmasq_nameservers:
          - 10.10.10.1
          - 10.10.10.2
        dnsmasq_searchdomain: example.com
````
