require 'spec_helper'

describe 'foreman_proxy::plugin::dhcp::infoblox' do
  let :facts do
    on_supported_os['redhat-7-x86_64']
  end

  let :pre_condition do
    'include ::foreman_proxy'
  end

  context 'default parameters' do
    let :params do
      {
        :username   => 'admin',
        :password   => 'infoblox',
      }
    end

    it { should compile.with_all_deps }

    it 'should install the correct plugin' do
      should contain_foreman_proxy__plugin('dhcp_infoblox')
    end

    it 'should contain the correct configuration' do
      verify_exact_contents(catalogue, '/etc/foreman-proxy/settings.d/dhcp_infoblox.yml', [
        '---',
        ':username: "admin"',
        ':password: "infoblox"',
        ':record_type: "fixedaddress"',
        ':use_ranges: false',
      ])
    end
  end

  context 'all parameters' do
    let :params do
      {
        :username    => 'admin',
        :password    => 'infoblox',
        :use_ranges  => true,
        :record_type => 'host'
      }
    end

    it 'should contain the correct configuration' do
      verify_exact_contents(catalogue, '/etc/foreman-proxy/settings.d/dhcp_infoblox.yml', [
        '---',
        ':username: "admin"',
        ':password: "infoblox"',
        ':record_type: "host"',
        ':use_ranges: true',
      ])
    end
  end

  context 'invalid parameters' do
    let :params do
      {
        :username    => 'admin',
        :password    => 'infoblox',
        :record_type => 'missing'
      }
    end

    it { expect { subject.call } .to raise_error(/Invalid record type: choose host or fixedaddress/) }
  end
end
