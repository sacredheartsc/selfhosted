Gssproxy Client
===============

Description
-----------

The `gssproxy_client` role configures a [gssproxy](https://github.com/gssapi/gssproxy)
service. `gssproxy` is a privileged middleware daemon that keeps track of
Kerberos keytabs and credential caches on behalf of unprivileged applications.

When an application needs a keytab (either to provide Kerberized services or
act as a Kerberos client), we prefer to use `gssproxy` rather than give the
application direct access to the keytab. `gssproxy` provides an extra layer of
security by allowing applications to use the keytab for authentication without
reading its contents.

Variables
---------

This role **accepts** the following variables:

Variable                 | Default | Description
-------------------------|---------|------------
`gssproxy_name`          | &nbsp;  | Config file name
`gssproxy_priority`      | 50      | Config file priority
`gssproxy_section`       | &nbsp;  | INI section name within config file
`gssproxy_client_keytab` | &nbsp;  | Path to client keytab
`gssproxy_keytab`        | &nbsp;  | Path to acceptor keytab
`gssproxy_euid`          | &nbsp;  | For client processes, match the given effective UID
`gssproxy_program`       | &nbsp;  | For client processes, match the given executable
`gssproxy_cred_usage`    | both    | Either `accept`, `initiate`, or `both`


Usage
-----

Example task:

````yaml
- name: configure gssproxy for kerberized HTTP
  include_role:
    name: gssproxy_client
  vars:
    gssproxy_name: httpd
    gssproxy_section: service/HTTP
    gssproxy_keytab: /var/lib/gssproxy/clients/apache.keytab
    gssproxy_cred_usage: accept
    gssproxy_euid: apache
    gssproxy_program: /usr/sbin/httpd
````
