include foreman_proxy
class { 'foreman_proxy::plugin::remote_execution::script':
  ssh_log_level => 'debug',
}
