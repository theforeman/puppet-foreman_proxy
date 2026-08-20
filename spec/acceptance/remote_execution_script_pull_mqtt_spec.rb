require 'spec_helper_acceptance'

describe 'Scenario: install foreman-proxy with remote_execution script plugin with pull-mqtt'  do
  before(:context) { purge_foreman_proxy }

  context 'with default params' do
    include_examples 'the example', 'remote_execution_script_pull_mqtt.pp'

    it_behaves_like 'the default foreman proxy application'

    it_behaves_like 'the exposed feature', 'script'

    describe port(1883) do
      it { is_expected.to be_listening }
    end

    describe file('/etc/foreman-proxy/settings.d/remote_execution_ssh.yml') do
      it { should be_file }
      its(:content) { should match(%r{:mqtt_port: 1883}) }
      its(:content) { should match(%r{:mqtt_broker: #{host_inventory['fqdn']}}) }
    end

    describe file('/etc/mosquitto/foreman.acl') do
      it { should be_file }
      its(:content) { should match(%r{pattern read yggdrasil\/%u\/data\/in}) }
      its(:content) { should match(%r{pattern write yggdrasil\/%u\/control\/out}) }
      its(:content) { should match(%r{user #{host_inventory['fqdn']}}) }
      its(:content) { should match(%r{topic write yggdrasil\/\+\/data\/in}) }
      its(:content) { should match(%r{topic read yggdrasil\/\+\/control\/out}) }
    end

    describe x509_certificate('/etc/mosquitto/ssl/ssl_cert.pem') do
      it { should be_certificate }
      it { should be_valid }
    end

    describe file('/etc/mosquitto/ssl/ssl_cert.pem') do
      it { should be_file }
      it { should be_mode 440 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'mosquitto' }
    end

    describe x509_private_key('/etc/mosquitto/ssl/ssl_key.pem') do
      it { should_not be_encrypted }
      it { should be_valid }
      it { should have_matching_certificate('/etc/mosquitto/ssl/ssl_cert.pem') }
    end

    describe file('/etc/mosquitto/ssl/ssl_key.pem') do
      it { should be_file }
      it { should be_mode 440 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'mosquitto' }
    end

    describe x509_certificate('/etc/mosquitto/ssl/ssl_ca.pem') do
      it { should be_certificate }
      it { should be_valid }
    end

    describe file('/etc/mosquitto/ssl/ssl_ca.pem') do
      it { should be_file }
      it { should be_mode 440 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'mosquitto' }
    end
  end

  context 'with default mode (SSH) after enabling pull-mqtt' do
    include_examples 'the example', 'remote_execution_script.pp'

    it_behaves_like 'the default foreman proxy application'

    it_behaves_like 'the exposed feature', 'script'

    describe port(1883) do
      it { is_expected.not_to be_listening }
    end

    describe file('/etc/foreman-proxy/settings.d/remote_execution_ssh.yml') do
      it { should be_file }
      its(:content) { should_not match(%r{:mqtt_port: 1883}) }
      its(:content) { should_not match(%r{:mqtt_broker: #{host_inventory['fqdn']}}) }
    end

    describe file('/etc/mosquitto/foreman.acl') do
      it { should_not exist }
    end

    describe file('/etc/mosquitto/ssl/ssl_cert.pem') do
      it { should_not exist }
    end

    describe file('/etc/mosquitto/ssl/ssl_key.pem') do
      it { should_not exist }
    end

    describe file('/etc/mosquitto/ssl/ssl_ca.pem') do
      it { should_not exist }
    end
  end

end
