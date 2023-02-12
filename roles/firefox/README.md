Firefox
=======

Description
-----------

The `firefox` role configures the global Firefox [policy file](https://github.com/mozilla/policy-templates/blob/master/README.md),
and enables Wayland for the browser.

The global Firefox policy can be used to install extensions automatically and
enforce various browser settings.

The global policy is stored in [/usr/lib64/firefox/distribution/policies.json](templates/usr/lib64/firefox/distribution/policies.json.j2).


Variables
---------

This role **accepts** the following variables:

Variable                                   | Default                                | Description
-------------------------------------------|----------------------------------------|------------
`firefox_preferences`                      | `{}`                                   | List of `about:config` items to apply (see [format](#firefox_preferences) below)
`firefox_extensions`                       | `[]`                                   | List of extensions to install (see [format](#firefox_extensions) below)
`firefox_managed_bookmarks`                | `[]`                                   | List of bookmarks to add (see [format](#firefox_managed_bookmarks) below)
`firefox_managed_bookmarks_top_level_name` | `Intranet`                             | Folder name containing managed bookmarks
`firefox_homepage`                         | `about:home`                           | URL of homepage
`firefox_spnego_domains`                   | `['{{ domain }}']`                     | Domains for which Kerberos/GSSAPI authentication is allowed
`firefox_spnego_allow_non_fqdn`            | yes                                    | Allow GSSAPI authentication for short hostnames
`firefox_spnego_allow_proxies`             | yes                                    | Allow GSSAPI authentication over proxies
`firefox_disable_pocket`                   | yes                                    | Disable Firefox Pocket (social bookmarking)
`firefox_disable_snippets`                 | yes                                    | Disable Firefox Snippets (Mozilla advocacy spam)
`firefox_disable_app_update`               | yes                                    | Disable checking for updates
`firefox_disable_captive_portal`           | yes                                    | Disable captive portal detection
`firefox_disable_default_bookmarks`        | yes                                    | Disable default bookmarks added by Mozilla
`firefox_disable_feedback`                 | yes                                    | Disable Mozilla user feedback
`firefox_disable_accounts`                 | yes                                    | Disable Firefox Accounts
`firefox_disable_studies`                  | yes                                    | Disable Firefox Studies (beta features)
`firefox_disable_telemetry`                | yes                                    | Disable telemetry
`firefox_disable_default_browser_check`    | yes                                    | Disable checking for default browser
`firefox_disable_user_messaging`           | yes                                    | Disable "What's New" messaging on updates
`firefox_disable_dns_over_https`           | yes                                    | Disable DNS over HTTPS
`firefox_disable_search_suggestions`       | yes                                    | Disable search suggestions
`firefox_disable_highlights`               | yes                                    | Disable Firefox Highlights (usage-based recommendations)
`firefox_disable_safe_browsing`            | yes                                    | Disable Mozilla safe browsing
`firefox_disable_top_sites`                | yes                                    | Disable "Top Sites" recommendation
`firefox_disable_push_notifications`       | yes                                    | Disable Mozilla push notification service
`firefox_offer_to_save_logins_default`     | yes                                    | Offer to save usernames and passwords
`firefox_use_tracking_protection`          | no                                     | Use Firefox tracking protection
`firefox_update_extensions`                | yes                                    | Update extensions automatically
`firefox_cookie_behavior`                  | `reject-tracker-and-partition-foreign` | Set [cookie behavior](https://github.com/mozilla/policy-templates/blob/master/README.md#cookies)


### firefox\_preferences

The `firefox_preferences` variable is used to set `about:config` items. It
should contain a list of dictionaries of the following format:

Key                | Default   | Description
-------------------|-----------|------------
name               | &nbsp;    | Name of `about:config` item
value              | &nbsp;    | Value of `about:config` item
status             | `default` | Either `default`, `locked`, `user`, or `clear`


### firefox\_extensions

The `firefox_extensions` variable is used to install Firefox extensions. It
should contain a list of dictionaries of the following format:

Key                | Default                        | Description
-------------------|--------------------------------|------------
id                 | &nbsp;                         | Extension id (found in `manifest.json` file) 
name               | &nbsp;                         | Name of the extension
url                | `addons.mozilla.org` by `name` | URL of extension `.xpi` file
mode               | `normal_installed`             | Either `normal_installed`, `force_installed`, `allowed`, or `blocked`


### firefox\_managed\_bookmarks

The `firefox_managed_bookmarks` variable is used to add bookmarks for all users.
It should contain a list of dictionaries of the following format:

Key  | Default | Description
-----|---------|------------
name | &nbsp;  | Name of the bookmark
URL  | &nbsp;  | URL of the bookmark


Usage
-----

Example playbook:

````yaml
- hosts: linux_desktops
  roles:
    - role: firefox
      vars:
````
