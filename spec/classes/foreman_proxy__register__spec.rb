require 'spec_helper'

describe 'foreman_proxy::register' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      describe 'with default settings' do
        let :pre_condition do
          "include foreman_proxy"
        end

        it 'should install provider dependencies' do
          should contain_class('foreman::providers')
        end

        it 'should register the proxy' do
          should contain_class('foreman_proxy::register')
          should contain_foreman_smartproxy(facts[:fqdn]).with({
            'ensure'          => 'present',
            'base_url'        => "https://#{facts[:fqdn]}",
            'effective_user'  => 'admin',
            'url'             => "https://#{facts[:fqdn]}:8443",
            'consumer_key'    => /\w+/,
            'consumer_secret' => /\w+/,
            'ssl_ca'          => /\A\/.+\.pem\z/,
          })
        end

        it 'should collect features' do
          should contain_datacat_collector('foreman_proxy::enabled_features').with({
            'source_key'      => 'features',
            'target_resource' => "Foreman_smartproxy[#{facts[:fqdn]}]",
            'target_field'    => 'features',
          }).that_comes_before("Foreman_smartproxy[#{facts[:fqdn]}]")
        end

        context 'with datacat provider' do
          # Use a RAL catalog for resources with providers
          subject { catalogue.to_ral }

          # Run the datacat provider to populate the foreman_smartproxy resource and check
          # the resulting collected values (ensures datacat is correctly configured)
          before { subject.resource('Datacat_collector[foreman_proxy::enabled_features]').provider.exists? }

          it 'should populate features on foreman_smartproxy' do
            expect(subject.resource("Foreman_smartproxy[#{facts[:fqdn]}]").parameters[:features].should.sort).to match_array(["Logs", "Puppet", "Puppet CA", "TFTP"])
          end
        end
      end

      describe 'with overrides' do
        let :pre_condition do
          "class {'foreman_proxy':
            register_in_foreman   => true,
            foreman_base_url      => 'https://foreman.example.com',
            registered_name       => 'my_proxy',
            registered_proxy_url  => 'https://proxy.example.com:8443',
            oauth_consumer_key    => 'key',
            oauth_consumer_secret => 'secret',
            oauth_effective_user  => 'smartproxy',
          }"
        end

        it 'should register the proxy' do
          should contain_class('foreman_proxy::register')
          should contain_foreman_smartproxy('my_proxy').with({
            'ensure'          => 'present',
            'base_url'        => 'https://foreman.example.com',
            'effective_user'  => 'smartproxy',
            'url'             => 'https://proxy.example.com:8443',
            'consumer_key'    => 'key',
            'consumer_secret' => 'secret',
          })
        end
      end

      describe 'with ssl_port overrides' do
        let :pre_condition do
          "class {'foreman_proxy':
            register_in_foreman   => true,
            foreman_base_url      => 'https://foreman.example.com',
            registered_name       => 'my_proxy',
            oauth_consumer_key    => 'key',
            oauth_consumer_secret => 'secret',
            oauth_effective_user  => 'smartproxy',
            ssl_port              => 1234,
          }"
        end

        it 'should register the proxy' do
          should contain_class('foreman_proxy::register')
          should contain_foreman_smartproxy('my_proxy').with({
            'ensure'          => 'present',
            'base_url'        => 'https://foreman.example.com',
            'effective_user'  => 'smartproxy',
            'url'             => "https://#{facts[:fqdn]}:1234",
            'consumer_key'    => 'key',
            'consumer_secret' => 'secret',
          })
        end
      end

      describe 'with foreman_ssl_ca override' do
        let :pre_condition do
          "class {'foreman_proxy':
            register_in_foreman => true,
            foreman_ssl_ca      => '/etc/foreman/ssl/ca.pem',
          }"
        end

        it 'should register the proxy' do
          should contain_class('foreman_proxy::register')
          should contain_foreman_smartproxy(facts[:fqdn]).with({
            'ensure' => 'present',
            'ssl_ca' => '/etc/foreman/ssl/ca.pem',
          })
        end
      end

      describe 'with ssl_ca override' do
        let :pre_condition do
          "class {'foreman_proxy':
            register_in_foreman => true,
            ssl_ca              => '/etc/foreman/ssl/ca.pem',
          }"
        end

        it 'should register the proxy' do
          should contain_class('foreman_proxy::register')
          should contain_foreman_smartproxy(facts[:fqdn]).with({
            'ensure' => 'present',
            'ssl_ca' => '/etc/foreman/ssl/ca.pem',
          })
        end
      end

      describe 'disabled' do
        let :pre_condition do
          "class {'foreman_proxy': register_in_foreman => false}"
        end

        it 'should not register the proxy' do
          should contain_class('foreman_proxy::register')
          should_not contain_foreman_smartproxy(facts[:fqdn])
          should_not contain_datacat_collector('foreman_proxy::enabled_features')
        end
      end
    end
  end
end
