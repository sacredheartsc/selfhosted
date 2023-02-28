Apache
======

Description
-----------

The `apache` role installs the Apache webserver, generates common configuration
files, and configures the server for GSSAPI authentication (if requested).

Variables
---------

This role **accepts** the following variables:

Variable                         | Default   | Description
---------------------------------|-----------|------------
`apache_use_nfs`                 | no        | Value of the `httpd_use_nfs` SELinux boolean
`apache_can_network_relay`       | yes       | Value of the `httpd_can_network_relay` SELinux boolean
`apache_can_network_connect`     | no        | Value of the `httpd_can_network_connect` SELinux boolean
`apache_can_network_connect_db`  | no        | Value of the `httpd_can_network_connect_db` SELinux boolean
`apache_can_connect_ldap`        | no        | Value of the `httpd_can_connect_ldap` SELinux boolean
`apache_can_sendmail`            | no        | Value of the `httpd_can_sendmail` SELinux boolean
`apache_gssapi`                  | no        | Enable FreeIPA authentication in virtualhosts via [https://github.com/gssapi/mod\_auth\_gssapi](https://github.com/gssapi/mod_auth_gssapi) or [mod\_ldap](https://httpd.apache.org/docs/2.4/mod/mod_ldap.html)
`apache_sysaccount_username`     | `apache`  | FreeIPA [sysaccount](https://www.freeipa.org/page/HowTo/LDAP#System_Accounts) uid to create for LDAP queries
`apache_sysaccount_password`     | &nbsp;    | FreeIPA [sysaccount](https://www.freeipa.org/page/HowTo/LDAP#System_Accounts) password for LDAP queries

This role **exports** the following variables:

Variable            | Description
--------------------|------------
`apache_public_dir` | Path of the webroot directory (`/var/www`)

Usage
-----

Example playbook:

````yaml
- name: configure apache
  hosts: webservers
  roles:
    - role: apache
      vars:
        apache_can_network_connect: yes
        apache_gssapi: yes
        apache_sysaccount_password: s3cret
````
