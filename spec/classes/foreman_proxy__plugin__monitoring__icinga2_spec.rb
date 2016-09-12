require 'spec_helper'

describe 'foreman_proxy::plugin::monitoring::icinga2' do
  let :facts do
    on_supported_os['redhat-7-x86_64']
  end

  let :pre_condition do
    'include ::foreman_proxy'
  end

  context 'default parameters' do
    it { should compile.with_all_deps }

    it 'should contain the correct configuration' do
      verify_exact_contents(catalogue, '/etc/foreman-proxy/settings.d/monitoring_icinga2.yml', [
        '---',
        ':enabled: true',
        ':server: "foo.example.com"',
        ':api_cacert: "/etc/foreman-proxy/monitoring/ca.crt"',
        ':api_user: "foreman"',
        ':api_usercert: "/etc/foreman-proxy/monitoring/foreman.crt"',
        ':api_userkey: "/etc/foreman-proxy/monitoring/foreman.key"',
        ':verify_ssl: true',
      ])
    end

    it { is_expected.to contain_class('foreman_proxy::plugin::monitoring') }
  end

  context 'without api_password' do
    let :params do
      {
        :enabled      => false,
        :server       => 'myicingaserver.local',
        :api_cacert    => '/tmp/ca.pem',
        :api_user     => 'hans',
        :api_usercert => '/tmp/user.pem',
        :api_userkey  => '/tmp/key.pem',
        :verify_ssl   => false
      }
    end

    it { should compile.with_all_deps }

    it 'should contain the correct configuration' do
      verify_exact_contents(catalogue, '/etc/foreman-proxy/settings.d/monitoring_icinga2.yml', [
        '---',
        ':enabled: false',
        ':server: "myicingaserver.local"',
        ':api_cacert: "/tmp/ca.pem"',
        ':api_user: "hans"',
        ':api_usercert: "/tmp/user.pem"',
        ':api_userkey: "/tmp/key.pem"',
        ':verify_ssl: false'
      ])
    end
  end

  context 'with api_password' do
    let :params do
      {
        :enabled      => false,
        :server       => 'myicingaserver.local',
        :api_cacert    => '/tmp/ca.pem',
        :api_user     => 'hans',
        :api_password => '1234',
        :verify_ssl   => false
      }
    end

    it { should compile.with_all_deps }

    it 'should contain the correct configuration' do
      verify_exact_contents(catalogue, '/etc/foreman-proxy/settings.d/monitoring_icinga2.yml', [
        '---',
        ':enabled: false',
        ':server: "myicingaserver.local"',
        ':api_cacert: "/tmp/ca.pem"',
        ':api_user: "hans"',
        ':api_password: "1234"',
        ':verify_ssl: false'
      ])
    end
  end
end
