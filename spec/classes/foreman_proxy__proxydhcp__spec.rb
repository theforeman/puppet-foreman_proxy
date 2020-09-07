require 'spec_helper'

describe 'foreman_proxy' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do

      let(:params) do
        {
          dhcp: true,
          dhcp_managed: true,
          dhcp_provider: 'isc',
          dhcp_gateway: '192.0.2.1',
          # Disable some integration for faster compiles
          dns: false,
          tftp: false,
          puppet: false,
          puppetca: false,
        }
      end

      let(:leases_dir) {
        case facts[:osfamily]
        when 'RedHat'
          '/var/lib/dhcpd'
        when 'Debian'
          '/var/lib/dhcp'
        else
          '/var/db/dhcpd'
        end
      }

      context "on physical interface" do
        let :facts do
          facts.merge(
            ipaddress: '192.0.2.10',
            ipaddress_eth0: '192.0.2.10',
            netmask_eth0: '255.255.255.0',
            network_eth0: '192.0.2.0',
          )
        end

        let(:params) { super().merge(dhcp_interface: 'eth0') }

        it do
          should contain_class('dhcp')
            .with_dnsdomain(['example.com'])
            .with_nameservers(['192.0.2.10'])
            .with_interfaces(['eth0'])
            .with_pxeserver('192.0.2.10')
            .with_pxefilename('pxelinux.0')
        end

        it do
          should contain_dhcp__pool('example.com')
            .with_network('192.0.2.0')
            .with_mask('255.255.255.0')
            .with_range(nil)
            .with_gateway('192.0.2.1')
            .with_failover(nil)
        end

        it { should_not contain_class('dhcp::failover') }

        context "as manager of ACLs for dhcp", unless: ['FreeBSD', 'DragonFly'].include?(facts[:osfamily]) do
          let(:params) { super().merge(dhcp_manage_acls: true) }

          it { is_expected.to contain_class('dhcp').with_conf_dir_mode('0750') }

          it do should contain_exec('Allow foreman-proxy to read /etc/dhcp').
            with_command("setfacl -R -m u:foreman-proxy:rx /etc/dhcp")
          end

          it do should contain_exec("Allow foreman-proxy to read #{leases_dir}").
            with_command("setfacl -R -m u:foreman-proxy:rx #{leases_dir}")
          end
        end

        context "as manager of ACLs for dhcp for RedHat and Debian by default" do
          case facts[:osfamily]
          when 'RedHat', 'Debian'
            it do should contain_exec('Allow foreman-proxy to read /etc/dhcp').
              with_command('setfacl -R -m u:foreman-proxy:rx /etc/dhcp').
              with_unless('getfacl -p /etc/dhcp | grep user:foreman-proxy:r-x')
            end
          else
            it { should_not contain_exec('Allow foreman-proxy to read /etc/dhcp') }
          end

          case facts[:osfamily]
          when 'RedHat', 'Debian'
            it do should contain_exec("Allow foreman-proxy to read #{leases_dir}").
              with_command("setfacl -R -m u:foreman-proxy:rx #{leases_dir}").
              with_unless("getfacl -p #{leases_dir} | grep user:foreman-proxy:r-x")
            end
          else
            it { should_not contain_exec("Allow foreman-proxy to read #{leases_dir}") }
          end
        end

        context "with additional dhcp listen interfaces" do
          let(:params) { super().merge(dhcp_additional_interfaces: [ 'vlan8', 'vlan9', 'vlan120' ]) }

          it { should contain_class('dhcp').with_interfaces(['eth0', 'vlan8', 'vlan9', 'vlan120' ]) }
        end

        context "with one additional dhcp listen interface" do
          let(:params) { super().merge(dhcp_additional_interfaces: ['vlan83']) }

          it { should contain_class('dhcp').with_interfaces(['eth0', 'vlan83']) }
        end

        context "with additional dhcp listen interfaces wrongly specified as String data type" do
          let(:params) { super().merge(dhcp_additional_interfaces: 'vlan55') }

          it { should compile.and_raise_error(/expects an Array value, got String/) }
        end

        context "with additional dhcp listen interfaces wrongly specified as Hash data type" do
          let(:params) { super().merge(dhcp_additional_interfaces: { name: 'vlan55' }) }

          it { should compile.and_raise_error(/parameter 'dhcp_additional_interfaces' expects an Array value, got Struct/) }
        end

        context "with dhcp_search_domains" do
          let(:params) { super().merge(dhcp_search_domains: ['example.com', 'example.org']) }

          it { should contain_dhcp__pool('example.com').with_search_domains(['example.com','example.org']) }
        end

        context "with dhcp_pxeserver" do
          let(:params) { super().merge(dhcp_pxeserver: '203.0.113.10') }

          it { should contain_class('dhcp').with_pxeserver('203.0.113.10') }
        end

        context "as primary dhcp server" do
          let(:params) do
            super().merge(
              dhcp_node_type: 'primary',
              dhcp_peer_address: '203.0.113.40',
            )
          end

          it do
            should contain_class('dhcp::failover')
              .with_role('primary')
              .with_peer_address('203.0.113.40')
              .with_address('192.0.2.10')
          end
        end

        context "as secondary dhcp server" do
          let(:params) do
            super().merge(
              dhcp_node_type: 'secondary',
              dhcp_peer_address: '203.0.113.50',
            )
          end

          it do
            should contain_class('dhcp::failover')
              .with_role('secondary')
              .with_peer_address('203.0.113.50')
              .with_address('192.0.2.10')
          end
        end
      end

      context "on vlan interface" do
        let :facts do
          facts.merge(
            ipaddress_eth0_0: '203.0.113.10',
            netmask_eth0_0: '255.255.255.0',
            network_eth0_0: '203.0.113.0',
          )
        end

        let(:params) { super().merge(dhcp_interface: 'eth0.0') }

        it do
          should contain_class('dhcp')
            .with_dnsdomain(['example.com'])
            .with_nameservers(['203.0.113.10'])
            .with_interfaces(['eth0.0'])
            .with_pxeserver('203.0.113.10')
            .with_pxefilename('pxelinux.0')
        end

        it do
          should contain_dhcp__pool('example.com')
            .with_network('203.0.113.0')
            .with_mask('255.255.255.0')
            .with_range(nil)
            .with_gateway('192.0.2.1')
            .with_failover(nil)
        end

        it { should_not contain_class('dhcp::failover') }
      end

      context "on alias interface" do
        let :facts do
          facts.merge(
            ipaddress_eth0_0: '198.51.100.10',
            netmask_eth0_0: '255.255.255.0',
            network_eth0_0: '198.51.100.0',
          )
        end

        let(:params) { super().merge(dhcp_interface: 'eth0:0') }

        it do
          should contain_class('dhcp')
            .with_dnsdomain(['example.com'])
            .with_nameservers(['198.51.100.10'])
            .with_interfaces(['eth0:0'])
            .with_pxeserver('198.51.100.10')
            .with_pxefilename('pxelinux.0')
        end
        it do
          should contain_dhcp__pool('example.com')
            .with_network('198.51.100.0')
            .with_mask('255.255.255.0')
            .with_range(nil)
            .with_gateway('192.0.2.1')
            .with_failover(nil)
        end

        it { should_not contain_class('dhcp::failover') }
      end

      context "on a non-existing interface" do
        let(:facts) { facts }
        let(:params) { super().merge(dhcp_interface: 'doesnotexist') }

        it { should compile.and_raise_error(/Could not get the ip address from fact ipaddress_doesnotexist/) }
      end
    end
  end
end
