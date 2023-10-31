# = Ansible runner package installation
#
# $package_name:: Name of the package to install to provide 'ansible-runner' command
#
class foreman_proxy::plugin::ansible::runner (
  String  $package_name = $foreman_proxy::plugin::ansible::runner_package_name,
) {
  if $facts['os']['family'] == 'RedHat' {
    yumrepo { 'ansible-runner':
      ensure => absent,
      before => Package[$package_name],
    }
  }

  package { $package_name:
    ensure => 'installed',
  }
}
