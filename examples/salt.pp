yumrepo { 'salt-repo':
  descr   => 'Salt repo for RHEL/CentOS',
  baseurl => 'https://packages.broadcom.com/artifactory/saltproject-rpm/',
  gpgkey  => 'https://packages.broadcom.com/artifactory/api/security/keypair/SaltProjectKey/public',
  before  => Class['foreman_proxy::plugin::salt'],
}

include foreman_proxy
include foreman_proxy::plugin::salt
