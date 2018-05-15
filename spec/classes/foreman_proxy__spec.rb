require 'spec_helper'

describe 'foreman_proxy' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      describe 'with defaults' do
        it 'should include classes' do
          should contain_class('foreman_proxy::install')
          should contain_class('foreman_proxy::config')
          should contain_class('foreman_proxy::service')
          should contain_class('foreman_proxy::register')
        end
      end

      describe 'with realm_provider => ad' do
        let(:params) do
          {
            :realm_provider => 'ad',
            :ad_config => {
              'realm'             => 'EXAMPLE.COM',
              'domain_controller' => 'dc.example.com'
            }
          }
        end
        it 'should include ad realm' do
          should contain_class('foreman_proxy::plugin::realm::ad')
        end
      end
    end
  end
end
