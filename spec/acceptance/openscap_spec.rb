require 'spec_helper_acceptance'

describe 'Scenario: install foreman-proxy with openscap plugin', if: ['redhat', 'centos'].include?(os[:family]) do
  before(:context) { purge_foreman_proxy }

  include_examples 'the example', 'openscap.pp'

  it_behaves_like 'the default foreman proxy application'

  describe package('puppet-foreman_scap_client') do
    it { is_expected.to be_installed }
  end
end
