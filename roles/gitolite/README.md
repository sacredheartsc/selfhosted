Gitolite
========

Description
-----------

The `gitolite` role installs [Gitolite](https://gitolite.com/gitolite/index.html),
an access control layer for Git repositories.

Users are able to authenticate to Git using Kerberos/GSSAPI over HTTP, or via
the SSH key associated with their FreeIPA user account. In addition, Git access
can be restricted based on FreeIPA group memberships.

This role does not configure a webserver. Configuring Apache to support
HTTP-based clones alongside [cgit](../cgit/) is nontrivial; check out the
[git playbook](../../playbooks/git.yml) for how it's done.


Variables
---------

This role **accepts** the following variables:

Variable                | Default           | Description
------------------------|-------------------|------------
`gitolite_ssh_user`     | `git`             | Name of Git SSH user
`gitolite_admin_group`  | `role-git-admin`  | FreeIPA group allowed to modify `gitolite-admin` repo (will be created)
`gitolite_access_group` | `role-git-access` | FreeIPA group of users allowed to access Gitolite (will be created)
`gitolite_freeipa_user` | `s-gitolite`      | FreeIPA user for Gitolite LDAP queries (will be created)
`gitolite_anon_user`    | `nobody`          | Gitolite username mapped to anonymous Git requests

This role **exports** the following variables:

Variable                 | Description
-------------------------|------------
`gitolite_user`          | Local Unix user that owns Gitolite directory
`gitolite_home`          | Path to Gitolite directory
`gitolite_cgi_script`    | Path to Gitolite CGI script
`gitolite_archive_shell` | Shell command to archive Giolite repositories

Usage
-----

Example playbook:

````yaml
- name: configure gitolite
  hosts: git_servers
  roles:
    - role: gitolite
      vars:
        gitolite_ssh_user: git
        gitolite_admin_group: git-admins
        gitolite_access_group: git-users
````
