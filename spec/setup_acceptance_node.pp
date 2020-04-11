if $facts['os']['name'] == 'CentOS' and $facts['os']['release']['major'] == '7' {
  package { 'centos-release-scl-rh':
    ensure => installed,
  }
}
