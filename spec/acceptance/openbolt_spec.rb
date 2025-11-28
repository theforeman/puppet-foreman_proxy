require 'spec_helper_acceptance'

describe 'Scenario: install foreman-proxy with openbolt plugin'  do
  before(:context) { purge_foreman_proxy }

  include_examples 'the example', 'openbolt.pp'

  it_behaves_like 'the default foreman proxy application'

  it_behaves_like 'the exposed feature', 'openbolt'
end
