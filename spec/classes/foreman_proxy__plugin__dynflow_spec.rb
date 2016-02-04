require 'spec_helper'

describe 'foreman_proxy::plugin::dynflow' do
  describe 'with default settings' do
    let :facts do
      on_supported_os['redhat-7-x86_64']
    end

    let :pre_condition do
      "include foreman_proxy"
    end

    it { should contain_foreman_proxy__plugin('dynflow') }

    it 'should generate correct dynflow.yml' do
      verify_exact_contents(catalogue, "/etc/foreman-proxy/settings.d/dynflow.yml", [
          '---',
          ':enabled: https',
          ':database: /var/lib/foreman-proxy/dynflow/dynflow.sqlite',
          ':console_auth: true',
      ])
    end
  end
end
