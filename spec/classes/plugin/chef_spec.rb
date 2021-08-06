require 'spec_helper'

describe_plugin 'foreman_proxy::plugin::chef' do
  context 'chef plugin is enabled' do
    let :params do
      {
        :enabled => true
      }
    end

    include_examples 'a plugin with a settings file', 'chef' do
      let(:expected_config) do
        <<~CONFIG
        ---
        :enabled: https
        :chef_authenticate_nodes: true
        :chef_server_url: https://foo.example.com
        # smart-proxy client node needs to have some admin right on chef-server
        # in order to retrive all nodes public keys
        # e.g. 'host.example.net'
        :chef_smartproxy_clientname: foo.example.com
        # e.g. /etc/chef/client.pem
        :chef_smartproxy_privatekey: /etc/chef/client.pem

        # turning of chef_ssl_verify is not recommended as it turn off authentication
        # you can try set path to chef server certificate by chef_ssl_pem_file
        # before setting chef_ssl_verify to false
        # note that chef_ssl_pem_file must contain both private key and certificate
        # because chef-api 0.5 requires it
        :chef_ssl_verify: true
        # :chef_ssl_pem_file: /path
        CONFIG
      end
    end
  end

  context 'chef plugin is disabled' do
    let :params do
      {
        :enabled => false
      }
    end

    include_examples 'a plugin with a settings file', 'chef' do
      let(:expected_config) { /:enabled: false/ }
      let(:expected_enabled) { false }
    end
  end
end
