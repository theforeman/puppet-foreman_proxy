shared_examples 'the default foreman proxy application' do
  describe service('foreman-proxy') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe port(8000) do
    it { is_expected.not_to be_listening }
  end

  describe port(8443) do
    it { is_expected.to be_listening }
  end
end

shared_examples 'the exposed feature' do |feature|
  let(:feature) { feature }

  cert_dir = '/etc/foreman-proxy'
  describe curl_command("https://#{host_inventory['fqdn']}:8443/features", cacert: "#{cert_dir}/certificate.pem", cert: "#{cert_dir}/certificate.pem", key: "#{cert_dir}/key.pem") do
    its(:stdout) { should include(feature) }
    its(:exit_status) { should eq 0 }
  end
end
