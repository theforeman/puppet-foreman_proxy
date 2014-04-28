# Changelog

## 1.6.1
* Fix user shell path so it's valid on Debian (#5390)

## 1.6.0
* Add parameters for all Foreman 1.4 and realm (1.5) features

## 1.5.0
* Add dns_provider parameter
* Use ensure_packages for non-core wget package
* Remove template source from header for Puppet 3.5 compatibility
* Fix missing dependency on foreman module
* Fix top-scope variable without an explicit namespace

## 1.4.0
* Add $puppetrun_provider parameter
* Fix disabling of ssl_* settings when $ssl is false
* Puppet 2.6 support deprecated
* Fix stdlib dependency for librarian-puppet
