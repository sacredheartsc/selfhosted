PsiTransfer
======

Description
-----------

The `psitransfer` role installs and configures [PsiTransfer](https://github.com/psi-4ward/psitransfer),
a web application for sharing files.

This role configures the NodeJS application only; it does not configure a reverse
proxy.


Variables
---------

This role **accepts** the following variables:

Variable                       | Default                           | Description
-------------------------------|-----------------------------------|------------
`psitransfer_version`          | see [defaults](defaults/main.yml) | Git version to install
`psitransfer_port`             | 8080                              | Local listening port
`psitransfer_admin_password`   | &nbsp;                            | Password to access `/admin` page
`psitransfer_upload_cidrs`     | `[]`                              | CIDRs allowed to upload files
`psitransfer_admin_cidrs`      | `[]`                              | CIDRs allowed to access admin page
`psitransfer_max_file_size`    | `1 GB`                            | Maximum file size
`psitransfer_max_bucket_size`  | `5 GB`                            | Maximum upload group size
`psitransfer_max_preview_size` | `32 MB`                           | Maximum size for thumbnail generation

This role **exports** the following variables:

Variable                    | Description
----------------------------|------------
`psitransfer_apache_config` | Apache config block to configure a reverse proxy


Usage
-----

Example playbook:

````yaml
- name: configure psitransfer
  hosts: filedrop_servers
  roles:
    - role: psitransfer
      psitransfer_port: 8080
      psitransfer_admin_password: s3cret
      psitransfer_upload_cidrs:
        - 10.10.10.0/24
        - 10.10.11.0/24
      psitransfer_admin_cidrs:
        - 10.10.10.0/24

    - role: apache_vhost
      apache_server_name: psitransfer.example.com
      apache_server_aliases: []
      apache_letsencrypt: yes
      apache_config: '{{ psitransfer_apache_config }}'
````
