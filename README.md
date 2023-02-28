sacredheart-selfhosted
======================

An Ansible framework for selfhosted infrastructure, based on
[Rocky Linux](https://rockylinux.org/) and [FreeIPA](https://www.freeipa.org/).

## What is this?

This is a collection of Ansible roles for provisioning self-hosted applications,
configuring Linux infrastructure, and managing Linux desktops.

I use these Ansible playbooks to manage my entire digital footprint, including
baremetal servers, virtual machines, and desktop workstations.

Although this project is not intended to be a turn-key appliance, it should be
easy to adapt it to your own environment with some basic sysadmin skills. I've
provided an example inventory to get you started.

## Features

Modular Ansible roles are used to create virtual machines, apply common base
configuration, and configure each service. A summary of the included roles is
provided in the table below. For a complete listing, check out the [roles](roles)
directory.

Each role has its own README file that describes how it should be invoked and what
variables it accepts.

 Role                                       | Description 
--------------------------------------------|-------------
[proxmox\_instance](roles/proxmox_instance) | Automatically provisions a [Proxmox](https://www.proxmox.com/) VM with the given hardware and cloud-init configuration
[common](roles/common/meta/main.yml)        | Meta-role that pulls in common configuration roles (local repos, freeipa client, DNS/NTP, SSH keys, etc)
[freeipa\_server](roles/freeipa_server)     | [FreeIPA](https://www.freeipa.org/) provides provides identity management, access control, certificate management, and single sign-on
[yum\_mirror](roles/yum_mirror)             | Mirrors all package repositories locally
[dnf\_automatic](roles/dnf_automatic)       | Automatically updates packages, performs reboots and service restarts when necessary
[rsyslog\_server](roles/rsyslog_server)     | Centralized syslog storage using [Rsyslog](https://www.rsyslog.com/)
[postfix\_server](roles/postfix_server)     | Public-facing mail server using [Postfix](https://www.postfix.org/)
[dovecot](roles/dovecot)                    | [Dovecot](https://www.dovecot.org/) IMAP server, with full text and attachment search
[rspamd](roles/rspamd)                      | [Rspamd](https://rspamd.com/) spam filtering system
[sabredav](roles/sabredav)                  | [sabre/dav](https://sabre.io/) CalDAV and CardDAV server with custom FreeIPA integration
[prosody](roles/prosody)                    | [Prosody](https://prosody.im/) XMPP server
[gitolite](roles/gitolite)                  | Git repository with [Gitolite](https://gitolite.com/gitolite/index.html) access control
[cgit](roles/cgit)                          | [cgit](https://git.zx2c4.com/cgit/) web frontend for Git
[vaultwarden](roles/vaultwarden)            | [Bitwarden-compatible password manager](https://github.com/dani-garcia/vaultwarden)
[ttrss](roles/ttrss)                        | [Tiny Tiny RSS](https://tt-rss.org/) feed aggregator
[mediawiki](roles/mediawiki)                | [MediaWiki](https://www.mediawiki.org/) wiki platform
[jellyfin](roles/jellyfin)                  | [Jellyfin](https://jellyfin.org/) media system
[invidious](roles/invidious)                | [Invidious](https://invidious.io/) open source YouTube frontend
[nitter](roles/nitter)                      | [Nitter](https://github.com/zedeus/nitter) open source Twitter frontend
[teddit](roles/teddit)                      | [Teddit](https://codeberg.org/teddit/teddit) open source Reddit frontend
[hastebin](roles/hastebin)                  | [Hastebin](https://github.com/toptal/haste-server) open source pastebin
[psitransfer](roles/psitransfer)            | [PsiTransfer](https://github.com/psi-4ward/psitransfer) public file sharing
[nfs\_server](roles/nfs_server)             | Configures ZFS datasets, NFS exports, SMB shares, ACLs, and autofs maps.
[syncthing](roles/syncthing)                | Per-user [Syncthing](https://syncthing.net/) instances that sync files to your NFS home directory
[asterisk](roles/asterisk)                  | [Asterisk](https://www.asterisk.org/) PBX for VOIP phones
[nsd](roles/nsd)                            | Authoritative DNS server
[nagios\_server](roles/nagios_server)       | Monitors all hosts and services, automatically generated configuration
[znc](roles/znc)                            | [ZNC](https://znc.in/) IRC bouncer
[cups\_server](roles/cups_server)           | Centralized network printing
[unifi](roles/unifi)                        | [UniFi](https://www.ui.com/) controller for managing Ubiquiti access points
[freeradius](roles/freeradius)              | WPA Enterprise authentication for WiFi using FreeIPA credentials or SSL certificates

## Design Choices

### Ansible

All configuration is performed using Ansible playbooks. The Ansible [playbooks](playbooks)
are just the orchestration layer for the modular Ansible [roles](roles),
which do all the heavy lifting. All host metadata is stored in the [inventory](inventory-example).

Why Ansible? Ansible is awful. And full of YAML. And SLOW.

Unfortunately, it seems to be the least awful option out there:

  1. No agent. If you can SSH to a host you can configure it with Ansible.

  2. An insane number of community modules (admittedly, of varying quality...)

  3. Easy escape hatches. If you're knee deep in a YAML tarpit, it's easy to
     write a custom Python filter or module to do what you want.

  4. There's an extremely convenient [FreeIPA project](https://github.com/freeipa/ansible-freeipa)
     that lets you manage your entire FreeIPA domain with Ansible.

When you self-host, 80% of your effort is figuring out exactly what arcane Unix
incantations are needed to make the stupid $THING work in a reproducible way.
And since Ansible is ultimately just a YAML listing of tasks to execute, it
provides a nice self-documenting way of doing that.

Ansible has very little magic, so the YAML is often obtuse. But a positive
side of its stupid simplicity is that anyone can look at the task files and
easily deduce exactly what steps are needed to configure a given thing.
       
### Rocky Linux

All the roles are designed for [Rocky Linux 9](https://rockylinux.org/) (a
few roles still require version 8 due to package availability). 

Why Rocky Linux? Mostly due to the 10-year support cycle. I've been self-hosting
for a long time, and I'm now at a stage of life where fiddling with config files
to keep up with frequent version updates is no longer enjoyable. I take comfort
in knowing that I can coast on this setup for a decade before I need to get in
the weeds again.

I don't have any strong opinions about Rocky vs Alma; at the time, I thought
Rocky Linux had a cooler logo 😎

All my hosts run with SELinux **enabled**, because I dislike [making Dan Walsh weep](https://stopdisablingselinux.com/).
Often this required writing my own SELinux modules, but I made it work.

I chose a RedHat-based distro for the first-class FreeIPA support.

### FreeIPA

I use FreeIPA for 100% of authentication and authorization logic, and Kerberos/GSSAPI
for single sign-on (where possible).

All my desktop computers also run Rocky Linux, and are joined to my FreeIPA
domain. When you log in with GDM, you'll get a Kerberos ticket that is used by
[Firefox](roles/firefox), [Evolution](roles/evolution), and other applications
to automatically authenticate you without having to type your password again.

For services that don't support Kerberos (or devices that don't support it, like
smartphones), everything falls back to username/password authentication over TLS.

Authorization is performed using FreeIPA group memberships. This is especially
handy since FreeIPA supports nested groups. For example, all my family members
are a member of the FreeIPA group `mylastname`. If I want to grant them access
to `myapp`, I'll use a FreeIPA group called `role-myapp-access`, and then make
the group `mylastname` a member of that group.

FreeIPA is also used to provision TLS certificates for all internal hosts. For
non-managed devices like smartphones, you'll have to install the local FreeIPA
Root CA. (There is also a [certbot role](roles/certbot) for public-facing
services.)

### KVM Virtual Machines

Each of my applications runs on a dedicated Proxmox KVM virtual machine. The
[common](roles/common) role spins up a dedicated [Proxmox instance](roles/proxmox_instance)
on the fly when configuring a new VM for the first time.

You can certainly use any of the included roles on non-Proxmox hosts, and they
will work fine. Proxmox is just what I decided to use for my own homelab.
Why Proxmox? It's free, and I was already familiar with it.

I still run everything on KVM virtual machines. I briefly looked into Linux
containers, but decided against them. My environment relies heavily on NFS and
automount, both of which only barely work within containers at this point.

There's no Docker whatsoever in this project. Everything is installed from
official repos or [EPEL](https://docs.fedoraproject.org/en-US/epel/), and
and managed using plain old systemd units. For services that lack official RPMs,
the software is built locally from the upstream source repository during the
playbook.

### Networking

Each role that exposes a network service uses `0.0.0.0` for all available
interfaces.

It is assumed that you already have a working network. Other than setting VLAN
tags and `cloud-init` IP configuration for virtual machines, none of the playbooks
in this project touch your network infrastructure.

For my homelab, I don't expose anything to the internet unless absolutely
necessary. I run an [OPNsense](https://opnsense.org/) firewall and configure all
mobile devices with a persistent Wireguard VPN back to my intranet.

You can configure your network and VLANs however you see fit. I actually run everything
from a small rack of used eBay gear in my basement! I have a residential cable
internet connection, with a block of static IPv4 addresses from my ISP, and it
works fine for everything so far.

I use RFC1918 local IP addresses for all my VMs. For services that need to be publicly
accessible, like [SMTP](roles/postfix_server), [Asterisk](roles/asterisk), and [XMPP](roles/prosody),
I add a static IP alias to the WAN interface of my firewall and use a [1:1 NAT](https://docs.opnsense.org/manual/nat.html#one-to-one)
mapping.

### Monitoring

I use [Nagios](roles/nagios_server). I know. I KNOW! I'm sorry.

It's honestly perfect for my use case. I have a bunch of static VMs that once
built, basically never change. The [configs](roles/nagios_server/templates/etc/nagios/objects)
are all generated automatically from my Ansible inventory, and I get an email
whenever something goes wrong.

I don't use Nagios for any metrics gathering--only health checks. In addition
to the usual ping/disk usage/load/network interface/certificate validity checks,
I also have a few custom plugins that check for [failed systemd units](roles/nagios_client/files/usr/lib64/nagios/plugins/check_systemd),
[dead asterisk endpoints](roles/nagios_server/files/usr/lib64/nagios/plugins/check_asterisk_endpoints),
and other random stuff.

### Backup and Restore

In my environment, periodic backups are performed by the [archiver](roles/archive_server).
Basically, applications run periodic [archive jobs](roles/archive_job) that
write data to `/var/spool/archive`, and a special process `rsync`'s this data each
night to a central location.

In addition, [backup](playbooks/util/backup.yml) and [restore](playbooks/util/restore.yml)
playbooks are provided.

The [backup playbook](playbooks/util/backup.yml) will export all transient state
for each service (email inboxes, FreeIPA domain, PostgreSQL databases, etc) to
tarballs on the Ansible controller.

The [restore playbook](playbooks/util/restore.yml) will safely perform the
service-specific tasks necessary to restore each backup.

In a disaster recovery scenario, I can rebuild all my VMs from scratch using the
[site.yml playbook](playbooks/site.yml) playbook. Then, I can use the [restore playbook](playbooks/util/restore.yml)
(along with my most recent backup) to restore all the data for each service.
