sacredheart-selfhosted
======================

An Ansible framework for selfhosted infrastructure, based on
[Rocky Linux](https://rockylinux.org/) and [FreeIPA](https://www.freeipa.org/).

## What is this?

I believe that self-hosting our online services is the best way to recapture the
original pioneer spirit of the Internet. `sacredheart-selfhosted` is a collection
of Ansible roles based on multiple years of experience self-hosting my family's
digital infrastructure.

Although this project is not intended to be a turn-key appliance, it should be
easy to adapt it to your own environment with some basic sysadmin skills. I've
provided an example inventory to get you started.

## Prerequisites

The [example inventory](inventory-example) is based on my home network, which
consists of the following:

  - A residential internet connection with a handful of static IPv4 addresses.

  - Some desktop computers, laptops, VOIP phones, and a NAS.

  - A [Proxmox](https://www.proxmox.com/en/proxmox-ve) hypervisor for running
    virtual machines.

  - An [OPNsense](https://opnsense.org/) firewall and various VLANs for managing
    internet and intranet traffic.

It's assumed that you already have a working network. Other than setting VLAN
tags and `cloud-init` IP configuration for virtual machines, none of the playbooks
touch your network infrastructure.

## Design

`sacredheart-selfhosted` is designed for [Rocky Linux](https://rockylinux.org/)
9. A small number of roles require Rocky Linux 8 due to package availability.

There's no Docker, no containers, and no `curl | bash.` Everything is installed
from official repos or [EPEL](https://docs.fedoraproject.org/en-US/epel/),
and managed using systemd. For services that lack official RPMs, the software is
built locally from the upstream source repository during the playbook.

All network services listen on the local IP of the host. If you want to expose
a service to the internet, it is assumed that you will configure your firewall
for 1:1 NAT.

There is no IPv6 support whatsoever. If my ISP ever rolls out IPv6, I'll look
into it.

## Features

Modular [Ansible roles](roles) are used to manage VMs and configure each service.

| Role                                      | Description |
--------------------------------------------|-------------|
[proxmox\_instance](roles/proxmox_instance) | Automatically provisions a [Proxmox](https://www.proxmox.com/) VM with the given hardware and cloud-init configuration
[freeipa\_server](roles/freeipa_server)     | [FreeIPA](https://www.freeipa.org/) provides provides identity management, access control, certificate management, and Single Sign-On for all services via Kerberos/GSSAPI
[yum\_mirror](roles/yum_mirror)             | Mirrors all package repositories locally
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

All services authenticate against the local FreeIPA domain. On a domain-joined
workstation, Kerberos/GSSAPI is used for single sign-on.

The [common.yml](playbooks/common.yml) playbook is a prerequisite for all services.
It joins the host to FreeIPA, adds the local yum repos, configures DNS and NTP, etc.

## Todo

Currently, this repository is just a big pile of YAML. More documentation and
how-to guides are coming soon!
