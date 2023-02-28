ZFS
===

Description
-----------

The `zfs` role configures ZFS pools and datasets.


Variables
---------

This role **accepts** the following variables:

Variable                      | Default   | Description
------------------------------|-----------|------------
`zfs_pools`                   | `[]`      | ZFS pools to create (see [format](#zfs_pools) below)
`zfs_datasets`                | `[]`      | ZFS datasets to create (see [format](#zfs_datasets) below)
`zfs_trim_on_calendar`        | `monthly` | Systemd [calendar interval](https://www.freedesktop.org/software/systemd/man/systemd.time.html#Calendar%20Events) for ZFS SSD trim
`zfs_scrub_on_calendar`       | `monthly` | Systemd [calendar interval](https://www.freedesktop.org/software/systemd/man/systemd.time.html#Calendar%20Events) for ZFS scrub
`zfs_zed_email`               | `root`    | Email address for ZFS Event Daemon (ZED) alerts
`zfs_zed_verbose`             | yes       | Show details in ZED emails
`zfs_zed_notify_interval_sec` | 3600      | Notification interval for ZED alerts (seconds)
`zfs_auto_snapshot_version`   | `master`  | Git version of [zfs-auto-snapshot](https://github.com/zfsonlinux/zfs-auto-snapshot) to install

### zfs\_pools

The `zfs_pools` variable specifies the ZFS pools to create on the host. It
should contain a list of dictionaries of the following format:

Key          | Default              | Description
-------------|----------------------|------------
`name`       | &nbsp;               | Name of the zpool
`properties` | `{}`                 | Dictionary of [zpool properties](https://openzfs.github.io/openzfs-docs/man/7/zpoolprops.7.html)
`mountpoint` | based on zpool name  | Mountpoint of zpool
`vdevs`      | &nbsp;               | List of vdevs for pool (see [format](#vdevs) below)

### vdevs

The `vdevs` property of the `zfs_pools` variable lists the vdevs that comprise
a given zpool. It should contain a list of dictionaries of the following format:

Key       | Default | Description
----------|---------|------------
`type`    | &nbsp;  | Either `raidz1`, `raidz2`, `raidz3`, `spare`, `log`, or `cache`
`devices` | &nbsp;  | List of device names for the vdev


### zfs\_datasets

The `zfs_datasets` variable specifies the ZFS filesystems to create on the
host. It should contain a list of dictionaries of the following format:

Key          | Default  | Description
-------------|----------|------------
`name`       | &nbsp;   | Dataset name
`properties` | `{}`     | Dictionary of [zfs properties](https://openzfs.github.io/openzfs-docs/man/7/zfsprops.7.html)


Usage
-----

Example playbook:

````yaml
- name: create ZFS pools
  hosts: nas1
  roles:
    - role: zfs
      vars:
        zfs_scrub_on_calendar: monthly
        zfs_trim_on_calendar: monthly
        zfs_zed_email: sysadmins@example.com
        zfs_pools:
          - name: tank
            mountpoint: /tank
            properties:
              ashift: 12
              autotrim: 'on'
            vdevs:
              - type: raidz2
                devices:
                  - /dev/disk/by-id/scsi-SSEAGATE_SSSSSSSSSSSS_00000001
                  - /dev/disk/by-id/scsi-SSEAGATE_SSSSSSSSSSSS_00000002
                  - /dev/disk/by-id/scsi-SSEAGATE_SSSSSSSSSSSS_00000003
                  - /dev/disk/by-id/scsi-SSEAGATE_SSSSSSSSSSSS_00000004
                  - /dev/disk/by-id/scsi-SSEAGATE_SSSSSSSSSSSS_00000005
                  - /dev/disk/by-id/scsi-SSEAGATE_SSSSSSSSSSSS_00000006
                  - /dev/disk/by-id/scsi-SSEAGATE_SSSSSSSSSSSS_00000007
                  - /dev/disk/by-id/scsi-SSEAGATE_SSSSSSSSSSSS_00000008
              - type: raidz2
                devices:
                  - /dev/disk/by-id/scsi-SSEAGATE_SSSSSSSSSSSS_00000009
                  - /dev/disk/by-id/scsi-SSEAGATE_SSSSSSSSSSSS_00000010
                  - /dev/disk/by-id/scsi-SSEAGATE_SSSSSSSSSSSS_00000011
                  - /dev/disk/by-id/scsi-SSEAGATE_SSSSSSSSSSSS_00000012
                  - /dev/disk/by-id/scsi-SSEAGATE_SSSSSSSSSSSS_00000013
                  - /dev/disk/by-id/scsi-SSEAGATE_SSSSSSSSSSSS_00000014
                  - /dev/disk/by-id/scsi-SSEAGATE_SSSSSSSSSSSS_00000015
                  - /dev/disk/by-id/scsi-SSEAGATE_SSSSSSSSSSSS_00000016
              - type: log
                devices:
                  - /dev/disk/by-id/nvme-INTEL_IIIIIIIIIIIII_000000000000000001

        zfs_datasets:
          - name: tank
            properties:
              compression: lz4
              acltype: posix
              xattr: sa
              relatime: 'on'
              com.sun:auto-snapshot:frequent: 'false'
````
