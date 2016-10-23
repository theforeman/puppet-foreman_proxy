require 'spec_helper'

describe 'foreman_proxy' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      it 'should include classes' do
        should contain_class('foreman_proxy::install')
        should contain_class('foreman_proxy::config')
        should contain_class('foreman_proxy::service')
        should contain_class('foreman_proxy::register')
      end
    end
  end
end
