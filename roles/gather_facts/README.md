Gather Facts
============

This role simply calls the Ansible `setup` module to gather facts about the host.

When building a new Proxmox VM, gathering facts at the start of the playbook
would fail because the VM does not yet exist. The [common](../common/) role
first builds the VM, then invokes this role once the host is reachable.
