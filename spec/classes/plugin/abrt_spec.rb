require 'spec_helper'

describe_plugin 'foreman_proxy::plugin::abrt' do
  describe 'with default settings' do
    include_examples 'a plugin with a settings file', 'abrt' do
      let(:expected_config) { /:enabled: https/ }
    end
  end

  describe 'with faf_ssl_* set' do
    let :params do {
      :faf_server_ssl_cert => '/faf_cert.pem',
      :faf_server_ssl_key => '/faf_key.pem',
    } end

    include_examples 'a plugin with a settings file', 'abrt' do
      # TODO: this is weaker than it was
      let(:expected_config) { %r{:server_ssl_(cert|key): /faf_\1\.pem} }
    end
  end
end
