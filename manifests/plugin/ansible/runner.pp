# = Ansible runner package installation
#
# $manage_runner_repo:: If true, adds upstream repositories to install ansible-runner package from
#
# $package_name:: Name of the package to install to provide 'ansible-runner' command
#
class foreman_proxy::plugin::ansible::runner(
  Boolean $manage_runner_repo = $foreman_proxy::plugin::ansible::manage_runner_repo,
  String  $package_name = $foreman_proxy::plugin::ansible::runner_package_name,
) {

  if $manage_runner_repo {
    case $facts['os']['family'] {
      'Debian': {
        include apt
        apt::source { 'ansible-runner':
          ensure  => absent,
        }
      }
      'RedHat': {
        yumrepo { 'ansible-runner':
          descr    => 'Ansible runner',
          baseurl  => "https://releases.ansible.com/ansible-runner/rpm/epel-${facts['os']['release']['major']}-\$basearch/",
          gpgcheck => true,
          gpgkey   => 'https://releases.ansible.com/keys/RPM-GPG-KEY-ansible-release.pub',
          enabled  => '1',
          before   => Package[$package_name],
        }
      }
      default: {
        fail("Repository containing 'ansible-runner' not known for '${facts['os']['family']}'")
      }
    }
  }

  package { $package_name:
    ensure => 'installed',
  }

}
