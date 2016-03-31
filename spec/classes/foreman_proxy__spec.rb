require 'spec_helper'

describe 'foreman_proxy' do
  on_supported_os.each do |os, facts|
    next if only_test_os() and not only_test_os.include?(os)
    next if exclude_test_os() and exclude_test_os.include?(os)
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
