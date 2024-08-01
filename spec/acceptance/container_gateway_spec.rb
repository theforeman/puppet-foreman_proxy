require 'spec_helper_acceptance'

describe 'Scenario: install foreman-proxy with container_gateway plugin', if: ['redhat', 'centos'].include?(os[:family]) do
  before(:context) { purge_foreman_proxy }

  include_examples 'the example', 'container_gateway.pp'

  it_behaves_like 'the default foreman proxy application'

  describe 'is created' do
    it { expect(package('rubygem-smart_proxy_container_gateway')).to be_installed }
    it { expect(file('/etc/foreman-proxy/settings.d/container_gateway.yml')).to be_file }
  end

  describe service("postgresql") do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe 'and purge it' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<~PUPPET
          include foreman_proxy
          class { 'foreman_proxy::plugin::container_gateway':
            version => 'absent',
          }
        PUPPET
      end

      describe 'it is purged' do
        it { expect(package('rubygem-smart_proxy_container_gateway')).not_to be_installed }
        it { expect(file('/etc/foreman-proxy/settings.d/container_gateway.yml')).not_to be_file }
      end
    end
  end
end
