Postfix Client
==============

Description
-----------

The `postfix_client` role installs [Postfix](https://www.postfix.org/) as the
local mail transfer agent, and configures it to relay all mail to a given STMP
server.


Variables
---------

This role **accepts** the following variables:

Variable                     | Default              | Description
-----------------------------|----------------------|------------
`postfix_relayhost`          | `{{ email_domain }}` | Next-hop destination for mail delivery (see [documentation](https://www.postfix.org/postconf.5.html#relayhost))
`postfix_myorigin`           | `{{ email_domain }}` | Default sender domain (see [documentation](https://www.postfix.org/postconf.5.html#myorigin))
`postfix_message_size_limit` | 67108864             | Maximum message size (bytes)


Usage
-----

Example playbook:

````yaml
- hosts: all
  roles:
    - role: postfix_client
      vars:
        postfix_relayhost: '[mx1.example.com]:25'
        postfix_myorigin: example.com
````
