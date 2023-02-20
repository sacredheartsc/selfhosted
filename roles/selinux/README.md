SELinux
=======

Description
-----------

The `selinux` role sets the SELinux enforcement policy, enables `auditd`, and
reboots the host (if necessary).

Variables
---------

This role **accepts** the following variables:

Variable          | Default | Description
------------------|---------|------------
`selinux_enabled` | yes     | `enforcing` if true, `disabled` if false


Usage
-----

Example playbook:

````yaml
- name: set selinux policy
  hosts: all
  roles:
    - role: selinux
      vars:
        selinux_enabled: yes
````
