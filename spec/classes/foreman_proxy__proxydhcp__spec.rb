require 'spec_helper'

describe 'foreman_proxy' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

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

      context "on physical interface" do
        let :facts do
          override_facts(super(), networking: {
            ip: '192.0.2.10',
            interfaces: {
              eth0: {
                ip: '192.0.2.10',
                netmask: '255.255.255.0',
                network: '192.0.2.0',
              },
            },
          })
        end

        let(:params) { super().merge(dhcp_interface: 'eth0') }

        it do
          should contain_class('dhcp')
            .with_dnsdomain(['example.com'])
            .with_nameservers(['192.0.2.10'])
            .with_interfaces(['eth0'])
            .with_pxeserver('192.0.2.10')
            .with_pxefilename('pxelinux.0')
            .with_ipxe_filename(nil)
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

        context "as manager of ACLs for dhcp", unless: ['FreeBSD', 'DragonFly'].include?(os_facts[:osfamily]) do
          let(:params) { super().merge(dhcp_manage_acls: true) }

          it { is_expected.to contain_class('dhcp').with_conf_dir_mode('0750') }

          it do should contain_exec('Allow foreman-proxy to read /etc/dhcp').
            with_command("setfacl -m u:foreman-proxy:rx /etc/dhcp")
          end
        end

        context "as manager of ACLs for dhcp for RedHat and Debian by default" do
          case os_facts[:osfamily]
          when 'RedHat', 'Debian'
            it do should contain_exec('Allow foreman-proxy to read /etc/dhcp').
              with_command('setfacl -m u:foreman-proxy:rx /etc/dhcp').
              with_unless('getfacl -p /etc/dhcp | grep user:foreman-proxy:r-x')
            end
          else
            it { should_not contain_exec('Allow foreman-proxy to read /etc/dhcp') }
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
          override_facts(super(), networking: {interfaces: {:'eth0.0' => {
            ip: '203.0.113.10',
            netmask: '255.255.255.0',
            network: '203.0.113.0',
          }}})
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
          override_facts(super(), networking: {interfaces: {:'eth0:0' => {
            ip: '198.51.100.10',
            netmask: '255.255.255.0',
            network: '198.51.100.0',
          }}})
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
        let(:params) { super().merge(dhcp_interface: 'doesnotexist') }

        it { should compile.and_raise_error(/Interface 'doesnotexist' was not found in networking facts/) }
      end

      context 'with templates' do
        let(:params) { super().merge(templates: true) }

        it { should compile.with_all_deps }
        it { should contain_class('dhcp').with_ipxe_filename('http://foo.example.com:8000/unattended/iPXE') }

        context 'with bootstrap' do
          let(:params) { super().merge(dhcp_ipxe_bootstrap: true) }

          it { should compile.with_all_deps }
          it { should contain_class('dhcp').with_ipxe_filename('http://foo.example.com:8000/unattended/iPXE?bootstrap=1') }
        end

        context 'with explicit parameter' do
          let(:params) { super().merge(dhcp_ipxefilename: 'http://customapi.example.com/boot') }

          it { should compile.with_all_deps }
          it { should contain_class('dhcp').with_ipxe_filename('http://customapi.example.com/boot') }
        end
      end

      context 'with httpboot' do
        let(:params) { super().merge(httpboot: true, dhcp_pxeserver: '192.0.2.123') }

        context 'with http' do
          let(:params) { super().merge(http: true) }

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_dhcp__dhcp_class('httpclients').with_parameters(%r{^    filename "http://192\.0\.2\.123:8000/EFI/grub2/shim\.efi";$}) }
        end

        context 'without http' do
          let(:params) { super().merge(http: false) }

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_dhcp__dhcp_class('httpclients').with_parameters(%r{^    filename "https://192\.0\.2\.123:8443/EFI/grub2/shim\.efi";$}) }
        end
      end
    end
  end
end
