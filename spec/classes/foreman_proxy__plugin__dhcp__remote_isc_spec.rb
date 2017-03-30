require 'spec_helper'

describe 'foreman_proxy::plugin::dhcp::remote_isc' do
  let :facts do
    on_supported_os['redhat-7-x86_64']
  end

  let :pre_condition do
    'include ::foreman_proxy'
  end

  context 'default parameters' do
    it { should compile.with_all_deps }

    it 'should install the correct plugin' do
      should contain_foreman_proxy__plugin('dhcp_remote_isc')
    end

    it 'should contain the correct configuration' do
      verify_exact_contents(catalogue, '/etc/foreman-proxy/settings.d/dhcp_remote_isc.yml', [
        '---',
        ":config: /etc/dhcp/dhcpd.conf",
        ":leases: /var/lib/dhcpd/dhcpd.leases",
        ':omapi_port: 7911'
      ])
    end
  end

  context 'all parameters' do
    let :params do
      {
        :dhcp_config => '/some/dir/dhcpd.conf',
        :dhcp_leases => '/another/dir/dhcpd.leases',
        :key_name    => 'some_key',
        :key_secret  => 'a_secret',
        :omapi_port  => 1234
      }
    end

    it 'should contain the correct configuration' do
      verify_exact_contents(catalogue, '/etc/foreman-proxy/settings.d/dhcp_remote_isc.yml', [
        '---',
        ":config: /some/dir/dhcpd.conf",
        ":leases: /another/dir/dhcpd.leases",
        ":key_name: some_key",
        ":key_secret: a_secret",
        ':omapi_port: 1234'
      ])
    end
  end
end
