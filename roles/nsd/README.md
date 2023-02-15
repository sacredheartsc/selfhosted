NSD
===

Description
-----------

The `nsd` role installs the `nsd` authoritative nameserver and generates zone
files.

Variables
---------

This role **accepts** the following variables:

Variable           | Default                         | Description
-------------------|---------------------------------|------------
`nsd_server_count` | `{{ ansible_processor_vcpus }}` | Number of server threads to run
`nsd_zones`        | `[]`                            | DNS zones to serve (see [format](#nsd_zones) below)
`nsd_default_ttl`  | 10800                           | Default record TTL (seconds)

### nsd\_zones

The `nsd_zones` variable is used to configure authoritative DNS zones to serve.
It should contain a list of dictionaries of the following format:

Key                 | Default                 | Description
--------------------|-------------------------|------------
`name`              | &nbsp;                  | DNS zone
`slave_nameservers` | `[]`                    | List of hosts to send notifies and allow zone transfers
`ttl`               | `{{ nsd_default_ttl }}` | Default TTL for this zone
`content`           | &nbsp;                  | Raw zone file content

Usage
-----

Example playbook:

````yaml
- hosts: authoritative_nameservers
  roles:
    - role: nsd
      vars:
        nsd_zones:
          - name: example.com
            slave_nameservers:
              - 203.0.113.50
              - 203.0.113.51
            ttl: 3600
            content: |
              @    IN  NS    ns1.example.com.
              @    IN  NS    ns2.example.com.
              ns1  IN  A     203.0.113.52
              ns1  IN  AAAA  2001:db8::2
              ns2  IN  A     203.0.113.53
              ns2  IN  AAAA  2001:db8::3

              @  IN  MX      10 mx1.example.com.
              @  IN  TXT     "v=spf1 mx -all"

              @           IN  A      203.0.113.54
              www1        IN  A      203.0.113.54
              mx1         IN  A      203.0.113.55
````
