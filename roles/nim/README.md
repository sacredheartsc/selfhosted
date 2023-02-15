Nim
===

Description
-----------

The `nim` role installs the [nim](https://nim-lang.org/) compiler. This is
currently only used as a dependency of the [nitter](../nitter/) role.

Variables
---------

This role **accepts** the following variables:

Variable      | Default                               | Description
--------------|---------------------------------------|------------
`nim_version` | see [default vars](defaults/main.yml) | Version of `nim` to install

This role **exports** the following variables:

Variable          | Description
------------------|------------
`nim_install_dir` | Directory containing `nim` executables
````
