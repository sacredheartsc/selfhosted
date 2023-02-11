Certbot
=======

Description
-----------

The `certbot` role retrieves a TLS certificate from LetsEncrypt.

Variables
---------

This role **accepts** the following variables:

Variable                 | Default                         | Description
-------------------------|---------------------------------|------------
`certificate_email`      | `root@{{ email_domain }}`       | LetsEncrypt contact email
`certificate_sans`       | `{{ [ansible_fqdn] + cnames }}` | Subject Alternative Names
`certificate_type`       | `ecdsa`                         | Either `ecdsa` or `rsa`
`certificate_size`       | 2048                            | RSA key size (bits)
`certificate_path`       | &nbsp;                          | Path of store certificate file
`certificate_key_path`   | &nbsp;                          | Path of certificate key file
`certificate_owner`      | `root`                          | Owner of certificate files (or `owner:group`)
`certificate_mode`       | 0400                            | File mode of certificate files
`certificate_use_apache` | no                              | Use exisiting Apache server for ACME challenge
`certificate_hook`       | &nbsp;                          | Command to `exec` after certificate renewal

Usage
-----

Example task:

````yaml
- name: request public TLS certificate
  include_role:
    name: certbot
  vars:
    certificate_sans:
      - example.com
      - www.example.com
    certificate_path: /etc/pki/tls/certs/example.com.crt
    certificate_key_path: /etc/pki/tls/private/example.com.key
    certificate_hook: systemctl reload httpd
````
