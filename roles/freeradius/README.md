FreeRADIUS
==========

Description
-----------

The `freeradius` role installs and configures [FreeRADIUS](https://freeradius.org/)
for WPA2/WPA3 Enterprise authentication.

Authentication is supported via FreeIPA-issued user certificates (TLS) or
username and password via TTLS-PAP.


Variables
---------

This role **accepts** the following variables:

Variable                  | Default               | Description
--------------------------|-----------------------|------------
`freeradius_clients`      | `[]`                  | List of RADIUS clients (see [format](#freeradius_clients) below)
`freeradius_ldap_servers` | `{{ freeipa_hosts }}` | LDAP hosts for PAP authentication
`freeradius_access_group` | `role-wifi-access`    | FreeIPA group for wifi access (will be created)

### freeradius\_clients

The `freeradius_clients` variable describes RADIUS client credentials. It should
contain a list of dictionaries of the following format:

Key        | Default | Description
-----------|---------|------------
`name`     | &nbsp;  | Friendly name
`address`  | &nbsp;  | Source address (IP or CIDR)
`secret`   | &nbsp;  | Shared encryption secret

Usage
-----

Example playbook:

````yaml
- name: configure freeradius
  hosts: radius_servers
  roles:
    - role: freeradius
      vars:
        freeradius_access_group: wifi-users
        freeradius_ldap_servers:
          - freeipa1.ipa.example.com
          - freeipa2.ipa.example.com

        freeradius_clients:
          - name: unifi
            address: 192.168.100.0/24
            secret: s3cret 
````
