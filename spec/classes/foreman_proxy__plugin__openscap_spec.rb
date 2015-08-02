require 'spec_helper'

describe 'foreman_proxy::plugin::openscap' do
  let :facts do
    on_supported_os['redhat-6-x86_64']
  end

  let :pre_condition do
    "include foreman_proxy"
  end

  context 'openscap plugin is enabled' do
    let :params do
      {
        :enabled => true
      }
    end

    it 'should call the plugin' do
      should contain_foreman_proxy__plugin('openscap')
    end

    it 'should install configuration file' do
      should contain_foreman_proxy__settings_file('openscap')
      verify_exact_contents(catalogue, '/etc/foreman-proxy/settings.d/openscap.yml', [
        '---',
        ':enabled: https',
        ':openscap_send_log_file: /var/log/foreman-proxy/openscap-send.log',
        ":spooldir: /var/spool/foreman-proxy/openscap",
      ])
    end
  end

  context 'openscap plugin is disabled' do
    let :params do
      {
        :enabled => false
      }
    end

    it 'should call the plugin' do
      should contain_foreman_proxy__plugin('openscap')
    end

    it 'should install configuration file' do
      should contain_foreman_proxy__settings_file('openscap')
      verify_exact_contents(catalogue, '/etc/foreman-proxy/settings.d/openscap.yml', [
        '---',
        ':enabled: false',
        ':openscap_send_log_file: /var/log/foreman-proxy/openscap-send.log',
        ":spooldir: /var/spool/foreman-proxy/openscap",
      ])
    end
  end
end
