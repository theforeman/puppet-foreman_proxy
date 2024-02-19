require 'spec_helper_acceptance'

describe 'Scenario: install foreman-proxy with openscap plugin', if: ['redhat', 'centos'].include?(os[:family]) do
  before(:context) { purge_foreman_proxy }

  include_examples 'the example', 'salt.pp'

  it_behaves_like 'the default foreman proxy application'

  specify { expect(file('/etc/salt/master.d')).to be_directory }
  specify { expect(file('/etc/salt/master.d/foreman.conf')).to be_file.and(have_attributes(owner: 'root', group: 'foreman-proxy')) }
end
