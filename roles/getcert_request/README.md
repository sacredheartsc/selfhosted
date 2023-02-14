getcert-request
===============

Description
-----------

The `getcert_request` role retrieves a TLS certificate from FreeIPA via the
`getcert` command. It uses [Certmonger](https://www.freeipa.org/page/Certmonger)
to track certificate renewals.


Variables
---------

This role **accepts** the following variables:

Variable                 | Default                             | Description
-------------------------|-------------------------------------|------------
`certificate_sans`       | `{{ [ansible_fqdn] + cnames }}`     | Subject Alternative Names
`certificate_service`    | `HTTP`                              | FreeIPA service prinicpal to own certificate (will be created)
`certificate_type`       | `rsa`                               | Either `ecdsa` or `rsa`
`certificate_size`       | 2048                                | RSA key size (bits)
`certificate_path`       | &nbsp;                              | Path of store certificate file
`certificate_key_path`   | &nbsp;                              | Path of certificate key file
`certificate_owner`      | `root`                              | Owner of certificate files (or `owner:group`)
`certificate_mode`       | 0400                                | File mode of certificate files
`certificate_hook`       | &nbsp;                              | Command to `exec` after certificate renewal
`certificate_resubmit`   | no                                  | Resubmit the certificate request, even if certificate file already exists
`certificate_hook_name`  | `{{ certificate_path | basename }}` | Filename of generated hook script (you probably don't need to change this)


Usage
-----

Example task:

````yaml
- name: request internal TLS certificate
  include_role:
    name: getcert_request
  vars:
    certificate_sans:
      - wiki1.ipa.example.com
      - wiki.ipa.example.com
    certificate_path: /etc/pki/tls/certs/wiki1.crt
    certificate_key_path: /etc/pki/tls/private/wiki1.key
    certificate_hook: systemctl reload httpd
````
