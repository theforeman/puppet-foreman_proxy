require 'spec_helper'

describe 'foreman_proxy::plugin::monitoring::icingadirector' do
  let :facts do
    on_supported_os['redhat-7-x86_64']
  end

  let :pre_condition do
    'include ::foreman_proxy'
  end

  context 'default parameters' do
    it { should compile.with_all_deps }

    it 'should contain the correct configuration' do
      verify_exact_contents(catalogue, '/etc/foreman-proxy/settings.d/monitoring_icingadirector.yml', [
        '---',
        ':enabled: true',
        ':director_url: "https://foo.example.com/icingaweb2/director"',
        ':director_cacert: "/etc/foreman-proxy/monitoring/ca.crt"',
        ':verify_ssl: true',
      ])
    end

    it { is_expected.to contain_class('foreman_proxy::plugin::monitoring') }
  end

  context 'with username and password' do
    let :params do
      {
        :director_user => 'foreman',
        :director_password => 'secret',
      }
    end

    it { should compile.with_all_deps }

    it 'should contain the correct configuration' do
      verify_exact_contents(catalogue, '/etc/foreman-proxy/settings.d/monitoring_icingadirector.yml', [
        '---',
        ':enabled: true',
        ':director_url: "https://foo.example.com/icingaweb2/director"',
        ':director_cacert: "/etc/foreman-proxy/monitoring/ca.crt"',
        ':director_user: "foreman"',
        ':director_password: "secret"',
        ':verify_ssl: true',
      ])
    end

    it { is_expected.to contain_class('foreman_proxy::plugin::monitoring') }
  end
end
