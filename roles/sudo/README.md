Sudo
====

Description
-----------

The `sudo` configures email alerts for failed sudo attempts. The sudo rules
themselves are configured within FreeIPA.


Variables
---------

This role **accepts** the following variables:

Variable           | Default | Description
-------------------|---------|------------
`sudo_send_emails` | yes     | Send email alerts for failed sudo attempts
`sudo_mailto`      | `root`  | Alert destination address


Usage
-----

Example playbook:

````yaml
- name: configure sudo logging
  hosts: all
  roles:
    - role: sudo
      vars:
        sudo_send_emails: yes
        sudo_mailto: sysadmins@example.com
````
