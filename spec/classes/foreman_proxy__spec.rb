require 'spec_helper'

describe 'foreman_proxy' do

  let (:facts) { {
    :osfamily => 'RedHat',
    :operatingsystem => 'CentOS',
    :operatingsystemrelease => '6',
  } }

  it { should include_class('foreman_proxy::install') }
  it { should include_class('foreman_proxy::config') }
  it { should include_class('foreman_proxy::service') }

end
