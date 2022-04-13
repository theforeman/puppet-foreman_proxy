include foreman_proxy
class { 'foreman_proxy::plugin::remote_execution::script':
  mode => 'pull-mqtt',
}
