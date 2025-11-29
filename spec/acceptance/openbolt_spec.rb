require 'spec_helper_acceptance'

describe 'Scenario: install foreman-proxy with openbolt plugin'  do
  before(:context) { purge_foreman_proxy }

  include_examples 'the example', 'openbolt.pp'

  it_behaves_like 'the default foreman proxy application'

  cert_dir = '/etc/foreman-proxy'
  describe curl_command("https://#{host_inventory['fqdn']}:8443/features", cacert: "#{cert_dir}/certificate.pem", cert: "#{cert_dir}/certificate.pem", key: "#{cert_dir}/key.pem") do
    its(:stdout) { should match('openbolt') }
    its(:exit_status) { should eq 0 }
  end
end
