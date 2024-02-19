$baseurl = "https://repo.saltproject.io/salt/py3/redhat/${facts['os']['release']['major']}/\$basearch/latest"

yumrepo { 'salt-repo':
  descr   => "Salt repo for RHEL/CentOS ${facts['os']['release']['major']} PY3",
  baseurl => $baseurl,
  gpgkey  => "${baseurl}/SALT-PROJECT-GPG-PUBKEY-2023.pub",
  before  => Class['foreman_proxy::plugin::salt'],
}

include foreman_proxy
include foreman_proxy::plugin::salt
