require 'spec_helper_acceptance'

describe 'Scenario: install foreman-proxy with discovery plugin'  do
  before(:context) { purge_foreman_proxy }

  include_examples 'the example', 'discovery.pp'

  it_behaves_like 'the default foreman proxy application'

  describe command('curl -sk https://127.0.0.1:8443/features | grep -q discovery') do
    its(:exit_status) { should eq 0 }
  end
end
