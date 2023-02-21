Tika
====

Description
-----------

The `tika` role installs and configures [Apache Tika](https://tika.apache.org/),
an open source document analysis platform.

This role is a meta dependency for [dovecot](../dovecot/), and is used to
index attachments for full-text IMAP search.


Variables
---------

This role **accepts** the following variables:

Variable              | Default                           | Description
----------------------|-----------------------------------|------------
`tika_version`        | see [defaults](defaults/main.yml) | Tika version to install
`tika_port`           | 9998                              | Local listening port
`tika_heap_size`      | `2g`                              | Java heap size limit
