require 'spec_helper'

describe 'foreman_proxy::plugin::dynflow' do
  describe 'with default settings' do
    let :facts do
      on_supported_os['redhat-7-x86_64']
    end

    let :pre_condition do
      "include foreman_proxy"
    end

    it { should contain_foreman_proxy__plugin('dynflow') }

    it 'should generate correct dynflow.yml' do
      verify_exact_contents(catalogue, "/etc/foreman-proxy/settings.d/dynflow.yml", [
          '---',
          ':enabled: https',
          ':database: /var/lib/foreman-proxy/dynflow/dynflow.sqlite',
          ':core_url: https://foo.example.com:8008',
      ])
    end

    it 'should generate correct dynflow core settings.yml' do
      verify_exact_contents(catalogue, "/etc/smart_proxy_dynflow_core/settings.yml", [
          "---",
          ":database: /var/lib/foreman-proxy/dynflow/dynflow.sqlite",
          ":console_auth: true",
          ":foreman_url: https://foo.example.com",
          ":listen: 0.0.0.0",
          ":port: 8008",
          ":use_https: true",
          ":ssl_ca_file: /var/lib/puppet/ssl/certs/ca.pem",
          ":ssl_certificate: /var/lib/puppet/ssl/certs/foo.example.com.pem",
          ":ssl_private_key: /var/lib/puppet/ssl/private_keys/foo.example.com.pem"
      ])
    end
  end
end
