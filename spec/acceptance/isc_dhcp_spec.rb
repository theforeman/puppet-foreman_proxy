require 'spec_helper_acceptance'

describe 'Scenario: install foreman-proxy with ISC DHCP', order: :defined do
  case fact('os.family')
  when 'Debian'
    service_name = 'isc-dhcp-server'
    leases_file = '/var/lib/dhcp/dhcpd.leases'
  else
    service_name = 'dhcpd'
    leases_file = '/var/lib/dhcpd/dhcpd.leases'
  end

  context 'default options' do
    include_examples 'the example', 'isc_dhcp.pp'

    it_behaves_like 'the default foreman proxy application'

    describe file('/etc/dhcp/dhcpd.conf') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_mode 644 }
      it { should_not contain(/secret/) }
    end

    describe service(service_name) do
      it { should be_enabled }
      it { should be_running }
    end

    omshell = <<~COMMAND
    omshell <<EOF
    server localhost
    port 7911
    connect
    new host
    set name = "host.example.com"
    set hardware-address = "00:11:22:33:44:55"
    set hardware-type = 1
    create
    remove
    EOF
    COMMAND

    describe command(omshell) do
      its(:stdout) { should match(/^name = "host\.example\.com"/) }
      its(:exit_status) { should eq 0 }
    end

    describe file(leases_file) do
      it { should contain(/host host\.example\.com/) }
    end

    describe file(leases_file) do
      before do
        # Lease updates are appended, so there's a create lease and delete
        # lease. Restarting the service rewrites the leases file to a short
        # version.
        on hosts, "systemctl restart #{service_name}"
      end

      it { should_not contain(/host host\.example\.com/) }
    end
  end

  context 'with omapi key' do
    include_examples 'the example', 'isc_dhcp_omapi.pp'

    it_behaves_like 'the default foreman proxy application'

    describe file('/etc/dhcp/dhcpd.conf') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'foreman-proxy' }
      it { should be_mode 640 }
      it { should contain(/secret "Ofakekeyfakekeyfakekey=="/) }
    end

    describe service(service_name) do
      it { should be_enabled }
      it { should be_running }
    end

    omshell_without_key = <<~COMMAND
    omshell <<EOF
    server localhost
    port 7911
    connect
    new host
    set name = "host-key.example.com"
    set hardware-address = "00:11:22:33:44:66"
    set hardware-type = 1
    create
    remove
    EOF
    COMMAND

    describe file(leases_file) do
      it { should_not contain(/host host-key\.example\.com/) }
    end

    describe command(omshell_without_key) do
      its(:stdout) { should match(/can't open object: no key specified/) }
    end

    omshell_with_key = <<~COMMAND
    omshell <<EOF
    key mykey "Ofakekeyfakekeyfakekey=="
    server localhost
    port 7911
    connect
    new host
    set name = "host-key.example.com"
    set hardware-address = "00:11:22:33:44:66"
    set hardware-type = 1
    create
    remove
    EOF
    COMMAND

    describe command(omshell_with_key) do
      its(:stdout) { should_not match(/can't open object: no key specified/) }
      its(:stdout) { should match(/^name = "host-key\.example\.com"/) }
    end

    describe file(leases_file) do
      it { should contain(/host host-key\.example\.com/) }
    end

    describe file(leases_file) do
      before do
        on hosts, "systemctl restart #{service_name}"
      end

      it { should_not contain(/host host-key\.example\.com/) }
    end
  end
end
