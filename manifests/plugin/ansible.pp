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
class foreman_proxy::plugin::ansible (
  Boolean $enabled = $::foreman_proxy::plugin::ansible::params::enabled,
  Foreman_proxy::ListenOn $listen_on = $::foreman_proxy::plugin::ansible::params::listen_on,
  Stdlib::Absolutepath $ansible_dir = $::foreman_proxy::plugin::ansible::params::ansible_dir,
  Optional[Stdlib::Absolutepath] $working_dir = $::foreman_proxy::plugin::ansible::params::working_dir,
) inherits foreman_proxy::plugin::ansible::params {

  validate_bool($enabled)
  validate_listen_on($listen_on)
  validate_absolute_path($ansible_dir)
  if $working_dir {
    validate_absolute_path($working_dir)
  }

  file {"${::foreman_proxy::dir}/.ansible.cfg":
    ensure  => file,
    content => template('foreman_proxy/plugin/ansible.cfg.erb'),
    owner   => 'root',
    group   => $::foreman_proxy::user,
    mode    => '0640',
  }

  include ::foreman_proxy::plugin::dynflow

  foreman_proxy::plugin { 'ansible':
  }
  -> foreman_proxy::settings_file { 'ansible':
    enabled       => $enabled,
    listen_on     => $listen_on,
    template_path => 'foreman_proxy/plugin/ansible.yml.erb',
  }

  if $::osfamily == 'RedHat' and $::operatingsystem != 'Fedora' {
    Foreman_proxy::Settings_file['ansible']
      ~> Service['smart_proxy_dynflow_core']
  }
}
