Apache VirtualHost
==================

Description
-----------

The `apache_vhost` role retrieves HTTPS certificates and generates an Apache
configuration file for a given [VirtualHost](https://httpd.apache.org/docs/2.4/vhosts/examples.html).


Variables
---------

This role **accepts** the following variables:

Variable                    | Default                                     | Description
----------------------------|---------------------------------------------|------------
`apache_server_name`        | `{{ ansible_fqdn }}`                        | [ServerName](https://httpd.apache.org/docs/2.4/mod/core.html#servername) value
`apache_server_aliases`     | `[]` if `apache_letsencrypt`, else `cnames` | [ServerAlias](https://httpd.apache.org/docs/2.4/mod/core.html#serveralias) values
`apache_config_name`        | `{{ apache_server_name }}`                  | Name of config file in `/etc/httpd/conf.d`
`apache_listen`             | `*`                                         | Network interface for VirtualHost
`apache_default_vhost`      | no                                          | Make this VirtualHost the default if no other VirtualHosts match the request
`apache_document_root`      | &nbsp;                                      | Path to [DocumentRoot](https://httpd.apache.org/docs/2.4/mod/core.html#documentroot)
`apache_autoindex`          | no                                          | Automatically generate file listings
`apache_use_ssl`            | yes                                         | Enable HTTPS
`apache_letsencrypt`        | no                                          | Use LetsEncrypt (rather than FreeIPA) to acquire certificates
`apache_redirect_to_https`  | yes                                         | 301 redirect HTTP requests to HTTPS
`apache_use_http2`          | yes                                         | Enable HTTP2 protocol
`apache_canonical_hostname` | &nbsp;                                      | 301 redirect all requests to this hostname
`apache_config`             | &nbsp;                                      | VirtualHost config block (see usage below)

The `apache_config` block is interpolated into the VirtualHost configuration file
at the appropriate location, based on the values of `apache_redirect_to_https`,
and `apache_use_ssl`, etc.

If `apache_document_root` is defined, and `apache_config` does not contain a
`<Directory>` block, a default one will be generated for you.

This role **exports** the following variables for use in the `apache_config` block:

Variable                       | Description
-------------------------------|------------
`apache_ldap_url`              | [AuthLDAPURL](https://httpd.apache.org/docs/2.4/mod/mod_authnz_ldap.html#authldapurl) value, based on FreeIPA LDAP servers and user base DN.
`apache_ldap_creds`            | Config lines for [AuthLDAPBindDN](https://httpd.apache.org/docs/2.4/mod/mod_authnz_ldap.html#authldapbinddn) and [AuthLDAPBindPassword](https://httpd.apache.org/docs/2.4/mod/mod_authnz_ldap.html#authldapbindpassword)
`apache_ldap_config`           | Config lines for [AuthLDAPUrl](https://httpd.apache.org/docs/2.4/mod/mod_authnz_ldap.html#authldapurl), [AuthLDAPBindDN](https://httpd.apache.org/docs/2.4/mod/mod_authnz_ldap.html#authldapbinddn), and [AuthLDAPBindPassword](https://httpd.apache.org/docs/2.4/mod/mod_authnz_ldap.html#authldapbindpassword)
`apache_gssapi_session_config` | Config lines for `mod_auth_gssapi` [session configuration](https://github.com/gssapi/mod_auth_gssapi#gssapiusesessions)
`apache_proxy_vhost_config`    | Common `ProxyPass` configuration
`apache_proxy_header_config`   | `RequestHeader` configuration for `ProxyPass`
`apache_proxy_config`          | `apache_proxy_vhost_config` + `apache_proxy_header_config` (you should generally include this before any `ProxyPass` lines)


Usage
-----

Example playbook:

````yaml
- name: create a vhost without HTTPS
  hosts: www1
  roles:
    - role: apache_vhost
      vars:
        apache_server_name: nohttps.example.com
        apache_document_root: /var/www/nohttps.example.com
        apache_use_ssl: no

- name: create a simple HTTPS vhost for www1.example.com
  hosts: www2
  roles:
    - role: apache_vhost
      vars:
        apache_document_root: /var/www/intranet.example.com

- name: create a reverse proxy
  hosts: www3
  roles:
    - role: apache_vhost
      vars:
        apache_config: |
          {{ apache_proxy_config }}
          ProxyPass        / http://127.0.0.1:8080/
          ProxyPassReverse / http://127.0.0.1:8080/

- name: create a reverse proxy with group-based authentication
  hosts: www4
  roles:
    - role: apache_vhost
      vars:
        apache_config: |
          ProxyPass        / http://127.0.0.1:8080/
          ProxyPassReverse / http://127.0.0.1:8080/
          {{ apache_proxy_config }}

          <Location />
            AuthName "FreeIPA Single Sign-On"
            # Use GSSAPI for clients in the kerberized_cidrs network, LDAP basic auth otherwise.
            <If "{% for cidr in kerberized_cidrs %}-R '{{ cidr }}'{% if not loop.last %} || {% endif %}{% endfor %}">
              AuthType GSSAPI
              GssapiLocalName On
              {{ apache_gssapi_session_config }}
            </If>
            <Else>
              AuthType Basic
              AuthBasicProvider ldap
            </Else>
            {{ apache_ldap_config }}
            Require ldap-attribute memberof=cn=role-app-access,{{ freeipa_group_basedn }}
          </Location>

- name: create a vhost with a LetsEncrypt certificate
  hosts: www5
  roles:
    - role: apache_vhost
      vars:
        apache_letsencrypt: yes
        apache_server_name: public.example.com
        apache_server_aliases:
          - www.example.com
          - some-cname.example.com
        apache_document_root: /var/www/public.example.com
````


Authentication Performance
-----------------------------------

To perform group-based authentication in Apache, the FreeIPA documentation [recommends](https://freeipa.readthedocs.io/en/latest/workshop/5-web-app-authnz.html#hbac-for-web-services)
using `mod_authnz_pam` along with a custom PAM service with a FreeIPA [HBAC](https://freeipa.readthedocs.io/en/latest/workshop/4-hbac.html)
rule.

While this does work, the performance is absolutely abysmal. With the recommended
configuration, Apache invokes a full PAM session (along with associated SSSD queries)
for every single HTTP request. There appears to be no caching whatsoever.

For simple HTML documents, I imagine this works well enough. But dynamic webapps
with many background HTTP calls are basically unusable.

### mod\_authnz\_ldap

`mod_authnz_ldap` provides robust caching out of the box, and supports group-
and attribute-based authorization. However, it lacks single sign-on capability
using GSSAPI--it's limited to HTTP Basic Auth.

### mod\_auth\_gssapi

`mod_auth_gssapi` provides single sign-on, and also supports session caching
using the `GssapiUseSessions` parameter for improved performance.

Unfortunately, the session caching only applies to GSSAPI logins. If you use the
`GssapiBasicAuth` option to fall back to username/password authentication, no
caching will take place, and `httpd` will (essentially) perform a full `kinit`
for each HTTP request--again killing performance.

### Solution

The solution I came up with was to force GSSAPI authentication for certain client
subnets, and use `mod_authnz_ldap`'s Basic authentication for everything else (see
play #4 in the example above). This works for my environment because my Linux
workstations are all on dedicated subnets.

If the client IP address matches a network in the `kerberized_cidrs` Ansible
variable, Apache uses GSSAPI authentication for the first request, and uses
Cookie-based session authentication thereafter.

If the client IP address does *not* match a kerberized CIDR, then Basic Auth
is used via `mod_authnz_ldap`. Although Basic Auth is still performed for every
HTTP request, `mod_authnz_ldap` caches the result for each username/password
combination, so the added latency is negligible.

In either case, any group-based authorization checks are performed by the
`mod_authnz_ldap` module. This is the only way I've found to get single sign-on
and group-based authorization working with acceptable latency in Apache.


ProxyPass with Unix Domain Sockets
----------------------------------

The syntax for creating a reverse proxy to a Unix domain socket is very
nonintuitive. It looks like this:

````apache
ProxyPass        unix:/path/to/socket.sock|http://foobar/
ProxyPassReverse unix:/path/to/socket.sock|http://foobar/
````

It doesn't matter what you choose for the `foobar` value, as long as it is
unique. If you have multiple `ProxyPass` directives for different locations
with the same `foobar` value, all requests will go to the same place!

I still don't quite understand the purpose of this, but now you know.
