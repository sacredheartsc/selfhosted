Solr
====

Description
-----------

The `solr` role installs and configures [Apache Solr](https://solr.apache.org/),
an open source search platform.

This role is a meta dependency for [dovecot](../dovecot/), and is used to
provide full-text IMAP search.


Variables
---------

This role **accepts** the following variables:

Variable              | Default                           | Description
----------------------|-----------------------------------|------------
`solr_version`        | see [defaults](defaults/main.yml) | Solr version to install
`solr_lucene_version` | see [defaults](defaults/main.yml) | Lucene compatibility version
`solr_port`           | 8983                              | Local listening port
`solr_heap_size`      | `2g`                              | Java heap size limit
`solr_softcommit_ms`  | 60000                             | Automatic softcommit interval (ms)
