# = Ansible runner package installation
#
# $manage_runner_repo:: If true, adds upstream repositories to install ansible-runner package from
#
# $package_name:: Name of the package to install to provide 'ansible-runner' command
#
class foreman_proxy::plugin::ansible::runner(
  Boolean $manage_runner_repo = $foreman_proxy::plugin::ansible::manage_runner_repo,
  String  $package_name = 'ansible-runner',
) {

  if $manage_runner_repo {
    case $facts['os']['family'] {
      'Debian': {
        include ::apt
        apt::source { 'ansible-runner':
          repos    => 'main',
          location => 'https://releases.ansible.com/ansible-runner/deb',
          key      => {
            id     => 'AC48AC71DA695CA15F2D39C4B84E339C442667A9',
            source => 'https://releases.ansible.com/keys/RPM-GPG-KEY-ansible-release.pub',
          },
          include  => {
            src => false,
          },
        }
      }
      'RedHat': {
        yumrepo { 'ansible-runner':
          descr    => 'Ansible runner',
          baseurl  => "https://releases.ansible.com/ansible-runner/rpm/epel-${facts['os']['release']['major']}-\$basearch}/",
          gpgcheck => true,
          gpgkey   => 'https://releases.ansible.com/keys/RPM-GPG-KEY-ansible-release.pub',
          enabled  => '1',
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
