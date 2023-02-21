Timezone
========

Description
-----------

The `timezone` role sets the system timezone, and ensures the system clock
uses UTC.

Variables
---------

This role **accepts** the following variables:

Variable   | Default   | Description
-----------|-----------|------------
`timezone` | `Etc/UTC` | System timezone


Usage
-----

Example playbook:

````yaml
- name: set timezone
  hosts: all
  roles:
    - role: timezone
      vars:
        timezone: America/New_York
````
