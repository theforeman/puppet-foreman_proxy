require 'spec_helper_acceptance'

describe 'Scenario: install foreman-proxy with container_gateway plugin', if: ['redhat', 'centos'].include?(os[:family]) do
  before(:context) { purge_foreman_proxy }

  include_examples 'the example', 'container_gateway.pp'

  it_behaves_like 'the default foreman proxy application'

  describe service("postgresql") do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end
end
