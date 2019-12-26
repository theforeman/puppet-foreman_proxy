# = Ansible proxy plugin
#
# This class installs Ansible support for Foreman proxy
#
# === Advanced parameters:
#
# $ansible_dir:: Ansible directory to search for available roles
#
# $working_dir:: A directory where the playbooks will be generated.
#                A tmp directory will be created when left blank
#
# $enabled::     Enables/disables the ansible plugin
#
# $listen_on::   Proxy feature listens on https, http, or both
#
# $host_key_checking:: Whether to ignore errors when a host is reinstalled
#                      so it has a different key in ~/.ssh/known_hosts
#                      If a host is not initially in 'known_hosts' setting
#                      this to True will result in prompting for confirmation
#                      of the key, which is not possible from non-interactive
#                      environments like Foreman Remote Execution or cron
#
# $stdout_callback:: Ansible's stdout_callback setting
#
# $roles_path:: Paths where we look for ansible roles.
#
# $ssh_args::          The ssh_args parameter in ansible.cfg under [ssh_connection]
#
# $install_runner:: If true, installs ansible-runner package to support running ansible by ansible-runner
#
# $manage_runner_repo:: If true, adds upstream repositories to install ansible-runner package from
#
class foreman_proxy::plugin::ansible (
  Boolean $enabled = true,
  Foreman_proxy::ListenOn $listen_on = 'https',
  Stdlib::Absolutepath $ansible_dir = '/usr/share/foreman-proxy',
  Stdlib::Absolutepath $working_dir = '/tmp',
  Boolean $host_key_checking = false,
  String $stdout_callback = 'yaml',
  Array[Stdlib::Absolutepath] $roles_path = ['/etc/ansible/roles', '/usr/share/ansible/roles'],
  String $ssh_args = '-o ProxyCommand=none -C -o ControlMaster=auto -o ControlPersist=60s',
  Boolean $install_runner = true,
  Boolean $manage_runner_repo = true,
) {
  $foreman_url = $::foreman_proxy::foreman_base_url
  $foreman_ssl_cert = pick($::foreman_proxy::foreman_ssl_cert, $::foreman_proxy::ssl_cert)
  $foreman_ssl_key = pick($::foreman_proxy::foreman_ssl_key, $::foreman_proxy::ssl_key)
  $foreman_ssl_ca = pick($::foreman_proxy::foreman_ssl_ca, $::foreman_proxy::ssl_ca)

  file {"${::foreman_proxy::etc}/foreman-proxy/ansible.cfg":
    ensure  => file,
    content => template('foreman_proxy/plugin/ansible.cfg.erb'),
    owner   => 'root',
    group   => $::foreman_proxy::user,
    mode    => '0640',
  }
  ~> file { "${::foreman_proxy::dir}/.ansible.cfg":
    ensure => link,
    target => "${::foreman_proxy::etc}/foreman-proxy/ansible.cfg",
  }

  include ::foreman_proxy::plugin::dynflow
  if $install_runner {
    include ::foreman_proxy::plugin::ansible::runner
  }

  foreman_proxy::plugin { 'ansible':
  }
  -> foreman_proxy::settings_file { 'ansible':
    enabled       => $enabled,
    feature       => 'Ansible',
    listen_on     => $listen_on,
    template_path => 'foreman_proxy/plugin/ansible.yml.erb',
  }

  if $::osfamily == 'RedHat' and $::operatingsystem != 'Fedora' {
    Foreman_proxy::Settings_file['ansible'] ~> Service['smart_proxy_dynflow_core']
  }
}
