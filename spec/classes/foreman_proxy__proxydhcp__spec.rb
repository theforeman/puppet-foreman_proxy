require 'spec_helper'

describe 'foreman_proxy::proxydhcp' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do

      context "on physical interface" do
        let :facts do
          facts.merge({:ipaddress_eth0 => '127.0.1.1',
                       :netmask_eth0   => '255.0.0.0',
                       :network_eth0   => '127.0.0.0'})
        end

        let :pre_condition do
          "class {'foreman_proxy':
            dhcp_gateway => '127.0.0.254',
          }"
        end

        it do should contain_class('dhcp').with(
          'dnsdomain'   => ['example.com'],
          'nameservers' => ['127.0.1.1'],
          'interfaces'  => ['eth0'],
          'pxeserver'   => '127.0.1.1',
          'pxefilename' => 'pxelinux.0'
        ) end

        it do should contain_dhcp__pool('example.com').with(
          'network'  => '127.0.0.0',
          'mask'     => '255.0.0.0',
          'range'    => nil,
          'gateway'  => '127.0.0.254',
          'failover' => nil
        ) end

        it { should_not contain_class('dhcp::failover') }
      end

      context "on vlan interface" do
        let :facts do
          facts.merge({:ipaddress_eth0_0 => '127.0.1.1',
                       :netmask_eth0_0   => '255.0.0.0',
                       :network_eth0_0   => '127.0.0.0'})
        end

        let :pre_condition do
          "class {'foreman_proxy':
            dhcp_gateway   => '127.0.0.254',
            dhcp_interface => 'eth0.0',
          }"
        end

        it do should contain_class('dhcp').with(
          'dnsdomain'   => ['example.com'],
          'nameservers' => ['127.0.1.1'],
          'interfaces'  => ['eth0.0'],
          'pxeserver'   => '127.0.1.1',
          'pxefilename' => 'pxelinux.0'
        ) end

        it do should contain_dhcp__pool('example.com').with(
          'network'  => '127.0.0.0',
          'mask'     => '255.0.0.0',
          'range'    => nil,
          'gateway'  => '127.0.0.254',
          'failover' => nil
        ) end

        it { should_not contain_class('dhcp::failover') }
      end

      context "on alias interface" do
        let :facts do
          facts.merge({:ipaddress_eth0_0 => '127.0.1.1',
                       :netmask_eth0_0   => '255.0.0.0',
                       :network_eth0_0   => '127.0.0.0'})
        end

        let :pre_condition do
          "class {'foreman_proxy':
            dhcp_gateway   => '127.0.0.254',
            dhcp_interface => 'eth0:0',
          }"
        end

        it do should contain_class('dhcp').with(
            'dnsdomain'   => ['example.com'],
            'nameservers' => ['127.0.1.1'],
            'interfaces'  => ['eth0:0'],
            'pxeserver'   => '127.0.1.1',
            'pxefilename' => 'pxelinux.0'
        ) end
        it do should contain_dhcp__pool('example.com').with(
            'network'  => '127.0.0.0',
            'mask'     => '255.0.0.0',
            'range'    => nil,
            'gateway'  => '127.0.0.254',
            'failover' => nil
        ) end

        it { should_not contain_class('dhcp::failover') }
      end

      context "with additional dhcp listen interfaces" do
        let :facts do
          facts.merge({:ipaddress_eth0 => '127.0.1.1',
                       :netmask_eth0   => '255.0.0.0',
                       :network_eth0   => '127.0.0.0'})
        end

        let :pre_condition do
          "class {'foreman_proxy':
            dhcp_gateway => '127.0.0.254',
            dhcp_additional_interfaces => [ 'vlan8', 'vlan9', 'vlan120' ],
          }"
        end

        it do should contain_class('dhcp').with(
          'dnsdomain'   => ['example.com'],
          'nameservers' => ['127.0.1.1'],
          'interfaces'  => ['eth0', 'vlan8', 'vlan9', 'vlan120' ],
          'pxeserver'   => '127.0.1.1',
          'pxefilename' => 'pxelinux.0'
        ) end

        it do should contain_dhcp__pool('example.com').with(
          'network'  => '127.0.0.0',
          'mask'     => '255.0.0.0',
          'range'    => nil,
          'gateway'  => '127.0.0.254',
          'failover' => nil
        ) end

        it { should_not contain_class('dhcp::failover') }
      end

      context "with one additional dhcp listen interface" do
        let :facts do
          facts.merge({:ipaddress_eth0 => '127.0.1.1',
                       :netmask_eth0   => '255.0.0.0',
                       :network_eth0   => '127.0.0.0'})
        end

        let :pre_condition do
          "class {'foreman_proxy':
            dhcp_gateway => '127.0.0.254',
            dhcp_additional_interfaces => [ 'vlan83' ]
          }"
        end

        it do should contain_class('dhcp').with(
          'dnsdomain'   => ['example.com'],
          'nameservers' => ['127.0.1.1'],
          'interfaces'  => ['eth0', 'vlan83'],
          'pxeserver'   => '127.0.1.1',
          'pxefilename' => 'pxelinux.0'
        ) end

        it do should contain_dhcp__pool('example.com').with(
          'network'  => '127.0.0.0',
          'mask'     => '255.0.0.0',
          'range'    => nil,
          'gateway'  => '127.0.0.254',
          'failover' => nil
        ) end

        it { should_not contain_class('dhcp::failover') }
      end

      context "with additional dhcp listen interfaces wrongly specified as String data type" do
        let :facts do
          facts.merge({:ipaddress_eth0 => '127.0.1.1',
                       :netmask_eth0   => '255.0.0.0',
                       :network_eth0   => '127.0.0.0'})
        end

        let :pre_condition do
          "class {'foreman_proxy':
            dhcp_gateway => '127.0.0.254',
            dhcp_additional_interfaces => 'vlan55',
          }"
        end
        it { should raise_error(Puppet::PreformattedError, /expects an Array value, got String/) }
      end

      context "with additional dhcp listen interfaces wrongly specified as Hash data type" do
        let :facts do
          facts.merge({:ipaddress_eth0 => '127.0.1.1',
                       :netmask_eth0   => '255.0.0.0',
                       :network_eth0   => '127.0.0.0'})
        end

        let :pre_condition do
          "class {'foreman_proxy':
            dhcp_gateway => '127.0.0.254',
            dhcp_additional_interfaces => { 'name' => 'vlan55' }
          }"
        end
        it { should raise_error(Puppet::PreformattedError, /expects an Array value, got Struct/) }
      end

      context "with dhcp_search_domains" do
        let :facts do
          facts.merge({:ipaddress_eth0 => '127.0.1.1',
                       :netmask_eth0   => '255.0.0.0',
                       :network_eth0   => '127.0.0.0'})
        end

        let :pre_condition do
          "class {'foreman_proxy':
            dhcp_gateway        => '127.0.0.254',
            dhcp_search_domains => ['example.com', 'example.org']
          }"
        end

        it do should contain_dhcp__pool('example.com').with(
            'search_domains' => ['example.com','example.org']
        ) end
      end

      context "with dhcp_pxeserver" do
        let :facts do
          facts.merge({:ipaddress_eth0 => '127.0.1.1',
                       :netmask_eth0   => '255.0.0.0',
                       :network_eth0   => '127.0.0.0'})
        end

        let :pre_condition do
          "class {'foreman_proxy':
            dhcp_pxeserver => '127.0.1.200'
          }"
        end

        it do should contain_class('dhcp').with(
            'pxeserver'   => '127.0.1.200',
        ) end
      end

      context "as primary dhcp server" do
        let :facts do
          facts.merge({:ipaddress_eth0 => '192.168.100.20',
                       :ipaddress      => '192.168.100.20',
                       :netmask_eth0   => '255.255.255.0',
                       :network_eth0   => '192.168.100.0'})
        end

        let :pre_condition do
          "class {'foreman_proxy':
            dhcp_range        => '192.168.100.1 192.168.100.10',
            dhcp_node_type    => 'primary',
            dhcp_peer_address => '192.168.1.21',
          }"
        end

        it do should contain_class('dhcp::failover').with(
            'role'         => 'primary',
            'peer_address' => '192.168.1.21',
            'address'      => '192.168.100.20'
        ) end

        it do should contain_class('dhcp').with(
            'dnsdomain'  => ['example.com'],
            'interfaces' => ['eth0']
        ) end
      end

      context "as secondary dhcp server" do
        let :facts do
          facts.merge({:ipaddress_eth0 => '192.168.100.21',
                       :ipaddress      => '192.168.100.21',
                       :netmask_eth0   => '255.255.255.0',
                       :network_eth0   => '192.168.100.0'})
        end

        let :pre_condition do
          "class {'foreman_proxy':
            dhcp_range        => '192.168.100.1 192.168.100.10',
            dhcp_node_type    => 'secondary',
            dhcp_peer_address => '192.168.1.20',
          }"
        end

        it do should contain_class('dhcp::failover').with(
            'role'         => 'secondary',
            'peer_address' => '192.168.1.20',
            'address'      => '192.168.100.21'
        ) end

        it do should contain_class('dhcp').with(
            'dnsdomain'  => ['example.com'],
            'interfaces' => ['eth0']
        ) end
      end

      context "on a non-existing interface" do
        let :facts do
          facts
        end

        let :pre_condition do
          "class { 'foreman_proxy':
            dhcp_interface => 'doesnotexist',
          }"
        end

        it { should raise_error(Puppet::Error, /Could not get the ip address from fact ipaddress_doesnotexist/) }
      end

      context "as manager of ACLs for dhcp" unless ['FreeBSD', 'DragonFly'].include?(facts[:osfamily]) do
        let :facts do
          facts.merge({:ipaddress_eth0 => '192.168.100.20',
                       :ipaddress      => '192.168.100.20',
                       :netmask_eth0   => '255.255.255.0',
                       :network_eth0   => '192.168.100.0'})
        end

        let :pre_condition do
          "class {'foreman_proxy':
            dhcp_manage_acls  => true,
          }"
        end

        it do should contain_exec('Allow foreman-proxy to read /etc/dhcp').
          with_command("setfacl -R -m u:foreman-proxy:rx /etc/dhcp")
        end

        it do should contain_exec('Allow foreman-proxy to read /var/lib/dhcpd').
          with_command("setfacl -R -m u:foreman-proxy:rx /var/lib/dhcpd")
        end
      end

      context "as manager of ACLs for dhcp for RedHat only by default" do
        let :facts do
          facts.merge({:ipaddress_eth0 => '192.168.100.20',
                       :ipaddress      => '192.168.100.20',
                       :netmask_eth0   => '255.255.255.0',
                       :network_eth0   => '192.168.100.0'})
        end

        let :pre_condition do
          "class {'foreman_proxy': }"
        end

        case facts[:osfamily]
        when 'RedHat'
          it do should contain_exec('Allow foreman-proxy to read /etc/dhcp').
            with_command('setfacl -R -m u:foreman-proxy:rx /etc/dhcp').
            with_unless('getfacl -p /etc/dhcp | grep user:foreman-proxy:r-x')
          end
        else
          it { should_not contain_exec('Allow foreman-proxy to read /etc/dhcp') }
        end

        case facts[:osfamily]
        when 'RedHat'
          it do should contain_exec('Allow foreman-proxy to read /var/lib/dhcpd').
            with_command("setfacl -R -m u:foreman-proxy:rx /var/lib/dhcpd").
            with_unless('getfacl -p /var/lib/dhcpd | grep user:foreman-proxy:r-x')
          end
        else
          it { should_not contain_exec('Allow foreman-proxy to read /var/lib/dhcpd') }
        end
      end
    end
  end
end
