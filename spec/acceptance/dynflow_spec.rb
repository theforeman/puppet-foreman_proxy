require 'spec_helper_acceptance'

describe 'Scenario: install foreman-proxy', unless: ENV['BEAKER_HYPERVISOR'] == 'docker'  do
  before(:context) { purge_foreman_proxy }

  include_examples 'the example', 'dynflow.pp'

  it_behaves_like 'the default foreman proxy application'

  it_behaves_like 'the exposed feature', 'dynflow'
end
