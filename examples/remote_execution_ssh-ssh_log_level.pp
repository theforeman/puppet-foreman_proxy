include foreman_proxy
class { 'foreman_proxy::plugin::remote_execution::ssh':
  ssh_log_level => 'debug',
}
