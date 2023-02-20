Redis
=====

Description
-----------

The `redis` role configures a local Redis instance on the specified port.
The database will be stored in `/var/lib/redis/$PORT`, so it's possible to run
multiple redis instances on the same host.


Variables
---------

This role **accepts** the following variables:

Variable                  | Default       | Description
--------------------------|---------------|------------
`redis_port`              | 6379          | Local listening port
`redis_max_memory`        | `2gb`         | Memory usage limit before eviction
`redis_max_memory_policy` | `allkeys-lru` | Eviction policy

This role **exports** the following variables:

Variable     | Description
-------------|------------
`redis_home` | Path to redis data directory

Usage
-----

Example playbook:

````yaml
- name: install redis
  hosts: test1
  roles:
    - role: redis
      vars:
        redis_port: 6379
        redis_max_memory: 2g
````
