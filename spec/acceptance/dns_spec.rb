require 'spec_helper_acceptance'

# On EL bind runs using PIDFile in systemd which is broken under docker
broken_pid_file = ENV['BEAKER_HYPERVISOR'] == 'docker' && host_inventory['facter']['os']['family'] == 'RedHat'
describe 'Scenario: install foreman-proxy', unless: broken_pid_file do
  before(:context) { purge_foreman_proxy }

  include_examples 'the example', 'dns.pp'

  it_behaves_like 'the default foreman proxy application'

  describe port(53) do
    it { is_expected.to be_listening }
  end

  cert_dir = '/etc/foreman-proxy'

  context 'forward dns' do
    describe command('dig +short SOA example.com @localhost') do
      its(:stdout) { is_expected.to match(/#{host_inventory['fqdn']}\. root\.example\.com\. \d+ 86400 3600 604800 3600\n/) }
    end

    describe command("curl --cacert #{cert_dir}/certificate.pem --cert #{cert_dir}/certificate.pem --key #{cert_dir}/key.pem https://$(hostname -f):8443/dns -X POST -d fqdn=integration.example.com -d value=192.0.2.100 -d type=A -s -w '%{http_code}'") do
      its(:stdout) { should eq('200') }
      its(:exit_status) { should eq 0 }
    end

    describe command('dig +short A integration.example.com @localhost') do
      its(:stdout) { is_expected.to eq("192.0.2.100\n") }
    end

    describe command("curl --cacert #{cert_dir}/certificate.pem --cert #{cert_dir}/certificate.pem --key #{cert_dir}/key.pem https://$(hostname -f):8443/dns/integration.example.com/A -X DELETE -s -w \'%{http_code}\'") do
      its(:stdout) { should eq('200') }
      its(:exit_status) { should eq 0 }
    end

    describe command('dig +short A integration.example.com @localhost') do
      its(:stdout) { is_expected.to eq('') }
    end
  end

  context 'reverse dns' do
    describe command('dig +short SOA 2.0.192.in-addr.arpa @localhost') do
      its(:stdout) { is_expected.to match(/#{host_inventory['fqdn']}\. root\.2\.0\.192\.in-addr\.arpa\. \d+ 86400 3600 604800 3600\n/) }
    end

    describe command("curl --cacert #{cert_dir}/certificate.pem --cert #{cert_dir}/certificate.pem --key #{cert_dir}/key.pem https://$(hostname -f):8443/dns -X POST -d fqdn=integration.example.com -d value=100.2.0.192.in-addr.arpa -d type=PTR -s -w '%{http_code}'") do
      its(:stdout) { should eq('200') }
      its(:exit_status) { should eq 0 }
    end

    describe command('dig +short -x 192.0.2.100 @localhost') do
      its(:stdout) { is_expected.to eq("integration.example.com.\n") }
    end

    describe command("curl --cacert #{cert_dir}/certificate.pem --cert #{cert_dir}/certificate.pem --key #{cert_dir}/key.pem https://$(hostname -f):8443/dns/100.2.0.192.in-addr.arpa/PTR -X DELETE -s -w \'%{http_code}\'") do
      its(:stdout) { should eq('200') }
      its(:exit_status) { should eq 0 }
    end

    describe command('dig +short -x 192.0.2.100 @localhost') do
      its(:stdout) { is_expected.to eq('') }
    end
  end
end
