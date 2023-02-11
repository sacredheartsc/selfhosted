Coturn
======

Description
-----------

The `coturn` role installs and configures the [coturn](https://github.com/coturn/coturn)
STUN/TURN server.


Variables
---------

This role **accepts** the following variables:

Variable          | Default              | Description
------------------|----------------------|------------
`coturn_port`     | 3478                 | Listening port
`coturn_min_port` | 49152                | Minimum UDP relay port
`coturn_max_port` | 65535                | Maximum UDP relay port
`coturn_realm`    | `{{ domain }}`       | Default realm for users


Usage
-----

Example playbook:

````yaml
- name: configure TURN/STUN servers
  hosts: turn_servers
  roles:
    - role: coturn
      vars:
        coturn_realm: example.com
````
