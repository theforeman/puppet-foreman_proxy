require 'spec_helper'

describe 'foreman_proxy::plugin::dns::route53' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'include foreman_proxy' }

      context 'explicit parameters' do
        let :params do
          {
            :aws_access_key => 'ABCDEF123456',
            :aws_secret_key => 'changeme',
          }
        end

        it { should compile.with_all_deps }

        it 'should install the correct plugin' do
          should contain_foreman_proxy__plugin('dns_route53')
        end

        it 'should contain the correct configuration' do
          verify_exact_contents(catalogue, '/etc/foreman-proxy/settings.d/dns_route53.yml', [
            '---',
            ':aws_access_key: "ABCDEF123456"',
            ':aws_secret_key: "changeme"',
          ])
        end
      end
    end
  end
end
