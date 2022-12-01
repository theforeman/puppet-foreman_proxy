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
# $roles_path:: Paths where we look for ansible roles.
#
# $ssh_args::          The ssh_args parameter in ansible.cfg under [ssh_connection]
#
# $install_runner:: If true, installs ansible-runner package to support running ansible by ansible-runner
#
# $callback:: The callback plugin to configure in ansible.cfg
#
# $runner_package_name:: The name of the ansible-runner package to install
#
# $collections_paths:: Paths where to look for ansible collections
#
class foreman_proxy::plugin::ansible (
  Boolean $enabled = $foreman_proxy::plugin::ansible::params::enabled,
  Foreman_proxy::ListenOn $listen_on = $foreman_proxy::plugin::ansible::params::listen_on,
  Stdlib::Absolutepath $ansible_dir = $foreman_proxy::plugin::ansible::params::ansible_dir,
  Optional[Stdlib::Absolutepath] $working_dir = $foreman_proxy::plugin::ansible::params::working_dir,
  Boolean $host_key_checking = $foreman_proxy::plugin::ansible::params::host_key_checking,
  Array[Stdlib::Absolutepath] $roles_path = $foreman_proxy::plugin::ansible::params::roles_path,
  String $ssh_args = $foreman_proxy::plugin::ansible::params::ssh_args,
  Boolean $install_runner = $foreman_proxy::plugin::ansible::params::install_runner,
  String $callback = $foreman_proxy::plugin::ansible::params::callback,
  String $runner_package_name = $foreman_proxy::plugin::ansible::params::runner_package_name,
  Array[Stdlib::Absolutepath] $collections_paths = $foreman_proxy::plugin::ansible::params::collections_paths,
) inherits foreman_proxy::plugin::ansible::params {
  $foreman_url = $foreman_proxy::foreman_base_url
  $foreman_ssl_cert = pick($foreman_proxy::foreman_ssl_cert, $foreman_proxy::ssl_cert)
  $foreman_ssl_key = pick($foreman_proxy::foreman_ssl_key, $foreman_proxy::ssl_key)
  $foreman_ssl_ca = pick($foreman_proxy::foreman_ssl_ca, $foreman_proxy::ssl_ca)

  file { "${foreman_proxy::config_dir}/ansible.env":
    ensure  => file,
    content => template('foreman_proxy/plugin/ansible.env.erb'),
    owner   => 'root',
    group   => $foreman_proxy::user,
    mode    => '0640',
  }

  include foreman_proxy::plugin::dynflow
  include foreman_proxy::plugin::remote_execution::script
  if $install_runner {
    include foreman_proxy::plugin::ansible::runner
  }

  foreman_proxy::plugin::module { 'ansible':
    enabled   => $enabled,
    listen_on => $listen_on,
  }
}
