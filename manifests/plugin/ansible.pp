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
# $enabled::     Enables/disables the plugin
#                type:boolean
#
# $listen_on::   Proxy feature listens on https, http, or both
#
class foreman_proxy::plugin::ansible (
  $enabled     = $::foreman_proxy::plugin::ansible::params::enabled,
  $listen_on   = $::foreman_proxy::plugin::ansible::params::listen_on,
  $ansible_dir = $::foreman_proxy::plugin::ansible::params::ansible_dir,
  $working_dir = $::foreman_proxy::plugin::ansible::params::working_dir,
) inherits foreman_proxy::plugin::ansible::params {

  validate_bool($enabled)
  validate_listen_on($listen_on)
  validate_absolute_path($ansible_dir)
  if $working_dir {
    validate_absolute_path($working_dir)
  }

  include ::foreman_proxy::plugin::dynflow

  foreman_proxy::plugin { 'ansible':
  } ->
  foreman_proxy::settings_file { 'ansible':
    enabled       => $enabled,
    listen_on     => $listen_on,
    template_path => 'foreman_proxy/plugin/ansible.yml.erb',
  } ~>
  Service['smart_proxy_dynflow_core']
}
