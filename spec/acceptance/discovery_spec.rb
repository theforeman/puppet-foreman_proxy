require 'spec_helper_acceptance'

describe 'Scenario: install foreman-proxy with discovery plugin'  do
  before(:context) { purge_foreman_proxy }

  include_examples 'the example', 'discovery.pp'

  it_behaves_like 'the default foreman proxy application'

  it_behaves_like 'the exposed feature', 'discovery'
end
