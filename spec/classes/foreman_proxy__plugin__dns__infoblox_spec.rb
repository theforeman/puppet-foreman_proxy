require 'spec_helper'

describe 'foreman_proxy::plugin::dns::infoblox' do
  let :facts do
    on_supported_os['redhat-7-x86_64']
  end

  let :pre_condition do
    'include ::foreman_proxy'
  end

  context 'valid parameters' do
    let :params do
      {
        :dns_server => 'localhost',
        :username   => 'admin',
        :password   => 'infoblox',
      }
    end

    it { should compile.with_all_deps }

    it 'should install the correct plugin' do
      should contain_foreman_proxy__plugin('dns_infoblox')
    end

    it 'should contain the correct configuration' do
      verify_exact_contents(catalogue, '/etc/foreman-proxy/settings.d/dns_infoblox.yml', [
        '---',
        ':dns_server: "localhost"',
        ':username: "admin"',
        ':password: "infoblox"',
      ])
    end
  end
end
