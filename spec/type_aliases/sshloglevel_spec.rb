require 'spec_helper'

describe 'Foreman_proxy::Sshloglevel' do
  # inconsistent with ssh_config(5)
  # see https://github.com/theforeman/smart_proxy_remote_execution_ssh/blob/master/lib/smart_proxy_remote_execution_ssh/plugin.rb#L3
  known_log_levels = %w[
    debug
    info
    error
    fatal
  ]
  it { is_expected.to allow_values(*known_log_levels) }
  it { is_expected.not_to allow_value(nil) }
  it { is_expected.not_to allow_value('all') }
  it { is_expected.not_to allow_value('loud') }
end
