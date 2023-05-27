Proxmox Instance
================

Description
-----------

The `proxmox_instance` role creates a new Proxmox virtual machine.

Each new virtual machine is cloned from the specified template VM, and
cloud-init properties are set to ensure static IP configuration and SSH keys are
set during the initial boot.

This role uses the [proxmox\_kvm](https://docs.ansible.com/ansible/latest/collections/community/general/proxmox_kvm_module.html)
module to create the virtual machines. Unfortunately, this module is pretty
limited--it's unable to modify disk or NIC configuration after the VM is cloned.
Therefore, we run some shell commands on the hypervisor to grow the disk, set
the VLAN tag, etc.

Note that this role uses `delegate_to` to run all tasks on the Proxmox server
itself. As a result, you can actually run it against a VM that doesn't yet
exist! This is how the [common](../common/) role creates VMs on-the-fly when
configuring a host for the first time.


Variables
---------

This role **accepts** the following variables:

Variable               | Default                        | Description
-----------------------|--------------------------------|------------
`proxmox_hostname`     | `{{ inventory_hostname }}`     | VM name
`proxmox_onboot`       | yes                            | Start VM automatically
`proxmox_bridge`       | `vmbr0`                        | Bridged virtual interface name
`proxmox_firewall`     | no                             | Enable Proxmox firewall
`proxmox_storage`      | `local-zfs`                    | Proxmox storage name
`proxmox_disk`         | 32                             | Size of virtual disk (GB)
`proxmox_memory`       | 4096                           | RAM (MB)
`proxmox_cpu`          | `host`                         | Virtual CPU model
`proxmox_sockets`      | 1                              | Virtual CPU sockets
`proxmox_cores`        | 2                              | Cores per socket
`proxmox_bios`         | `ovmf`                         | either `ovmf` or `seabios`
`proxmox_template`     | `rocky9.2`                     | Template VM name
`proxmox_vlan`         | `{{ vlan.id }}`                | Virtual NIC VLAN tag
`proxmox_ssd`          | yes                            | Emulate an SSD
`proxmox_discard`      | yes                            | Enable TRIM commands from guest
`proxmox_vga`          | `serial0`                      | Virtual console device
`proxmox_scsihw`       | `virtio-scsi-pci`              | Virtual SCSI device
`proxmox_guest_agent`  | yes                            | Guest uses `qemu-guest-agent`
`proxmox_username`     | `root`                         | Cloud-init username
`proxmox_password`     | `{{ root_password }}`          | Cloud-init password
`proxmox_pubkeys`      | `{{ root_authorized_keys }}`   | Cloud-init SSH public keys
`proxmox_ip`           | `{{ ip }}`                     | Cloud-init IP address
`proxmox_gateway`      | `{{ vlan.gateway }}`           | Cloud-init default gateway
`proxmox_netmask`      | `{{ vlan }}` prefix            | Cloud-init network prefix
`proxmox_nameservers`  | `{{ vlan.dns_servers }}`       | Cloud-init DNS servers
`proxmox_searchdomain` | `{{ domain }}`                 | Cloud-init DNS search domain
`proxmox_userdata`     | `local:snippets/userdata.yaml` | Cloud-init userdata file


Usage
-----

Example playbook:

````yaml
- name: create proxmox VM
  hosts: coolvm1
  roles:
    - role: proxmox_instance
      vars:
        proxmox_hostname: coolvm1
        proxmox_disk: 64
        proxmox_memory: 2048
        proxmox_cores: 4
        proxmox_template: rocky9.1
        proxmox_vlan: 101
        proxmox_username: root
        proxmox_password: r00tp@ssw0rd
        proxmox_ip: 10.10.10.99
        proxmox_gateway: 10.10.10.1
        proxmox_netmask: 24
        proxmox_nameservers:
          - 10.10.10.2
          - 10.10.10.3
        proxmox_searchdomain: example.com
````
