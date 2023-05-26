cgit
====

Description
-----------

The `cgit` role installs and configures [cgit](https://git.zx2c4.com/cgit/about/),
a web frontend for Git. It does _not_ configure a webserver.


Variables
---------

This role **accepts** the following variables:

Variable                 | Default                                                          | Description
-------------------------|------------------------------------------------------------------|------------
`cgit_clone_prefixes`    | `['https://{{ ansible_fqdn }}', 'ssh://git@{{ ansible_fqdn }}']` | Clone URLs to show on repository pages
`cgit_title`             | `{{ organization }} Git Repository`                              | Title shown on index page
`cgit_description`       | `Source code for various {{ organization }} projects`            | Subtitle shown on index page
`cgit_cache_size`        | 1000                                                             | Number of pages to cache
`cgit_project_list`      | `/var/www/git/projects.list`                                     | Path to repository list
`cgit_scan_path`         | `/var/www/git/repositories`                                      | Path containing Git repositories
`cgit_enable_http_clone` | no                                                               | Let cgit handle clones over HTTP
`cgit_repository_sort`   | `name`                                                           | Sort repositories by either `name` or `age`
`cgit_branch_sort`       | `name`                                                           | Sort branches by either `name` or `age`
`cgit_about_html`        | see [default vars](defaults/main.yml)                            | HTML to include in About page
`cgit_enable_blame`      | yes                                                              | Enable `git blame` functionality
`cgit_robots`            | `index, nofollow`                                                | Value for the `robots` meta tag
`cgit_favicon`           | &nbsp;                                                           | Path to custom favicon image
`cgit_logo`              | &nbsp;                                                           | Path to custom logo image (ideally 96x64)
`cgit_css`               | &nbsp;                                                           | Path to custom CSS file
`cgit_head_include`      | &nbsp;                                                           | Path to custom HTML `<head>` include
`cgit_header`            | &nbsp;                                                           | Path to custom HTML header

This role **exports** the following variables:

Variable          | Description
------------------|------------
`cgit_static_dir` | Path to static assets
`cgit_cgi_script` | Path to CGI binary


Usage
-----

Example playbook:

````yaml
- name: configure git repository
  hosts: git_servers
  roles:
    - role: cgit
      tags: cgit,git
      vars:
        cgit_clone_prefixes:
          - https://git.example.com
        cgit_title: Example Org Git Repository
        cgit_logo: ~/Pictures/cgit_logo.png
        cgit_favicon: ~/Pictures/cgit_favicon.ico
````
