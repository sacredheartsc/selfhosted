SELinux Policy
==============

Description
-----------

The `selinux_policy` role builds and installs a custom SELinux policy module.


Variables
---------

This role **accepts** the following variables:

Variable                 | Default | Description
-------------------------|---------|------------
`selinux_policy_name`    | &nbsp;  | Module name
`selinux_policy_version` | `1.0`   | Module version
`selinux_policy_te`      | &nbsp;  | SELinux Type Enforcement policy content


Usage
-----

Example task:

````yaml
- name: create SELinux policy for dovecot to access gssproxy
  include_role:
    name: selinux_policy
    apply:
      tags: selinux
  vars:
    selinux_policy_name: dovecot_gssproxy
    selinux_policy_te: |
      require {
        type autofs_t;
        type dovecot_t;
        type dovecot_auth_t;
        type dovecot_auth_exec_t;
        type dovecot_deliver_exec_t;
        type gssd_t;
        type gssproxy_t;
        type gssproxy_var_lib_t;
        class dir search;
        class sock_file write;
        class unix_stream_socket connectto;
        class process noatsecure;
        class file { read execute open getattr execute_no_trans map };
        class dir search;
        class key { read write };
      }

      ### The following rules are needed for dovecot to access gssproxy:
      #============= dovecot_auth_t ==============
      allow dovecot_auth_t gssproxy_t:unix_stream_socket connectto;
      allow dovecot_auth_t gssproxy_var_lib_t:dir search;
      allow dovecot_auth_t gssproxy_var_lib_t:sock_file write;
      allow dovecot_auth_t autofs_t:dir search;
      allow dovecot_auth_t gssd_t:key { read write };

      #============= dovecot_t ==============
      allow dovecot_t dovecot_auth_t:process noatsecure;
      allow dovecot_t dovecot_deliver_exec_t:file { read execute open getattr execute_no_trans };

      #============= gssproxy_t ==============
      allow gssproxy_t dovecot_auth_exec_t:file getattr;

      ### The following rules are needed for the delivery process to exec quota warning scripts:
      #============= dovecot_t ==============
      allow dovecot_t dovecot_deliver_exec_t:file { read execute open getattr execute_no_trans map };
````
