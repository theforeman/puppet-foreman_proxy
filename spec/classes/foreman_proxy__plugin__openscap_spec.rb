require 'spec_helper'

describe 'foreman_proxy::plugin::openscap' do
  let :facts do
    on_supported_os['redhat-7-x86_64']
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
        ':spooldir: /var/spool/foreman-proxy/openscap',
        ':contentdir: /var/lib/foreman-proxy/openscap/content',
        ':reportsdir: /var/lib/foreman-proxy/openscap/reports',
        ':failed_dir: /var/lib/foreman-proxy/openscap/failed',
        ':corrupted_dir: /var/lib/foreman-proxy/openscap/corrupted',

      ])
    end

    context 'with configure_openscap_repo set to true' do
      let :params do
        {
          :configure_openscap_repo => true
        }
      end

      it 'should install custom openscap repo' do
        repo_base = facts[:operatingsystem] == 'Fedora' ? 'fedora' : 'epel'
        should contain_yumrepo("isimluk-openscap").
          with_baseurl("http://copr-be.cloud.fedoraproject.org/results/isimluk/OpenSCAP/#{repo_base}-#{facts[:operatingsystemmajrelease]}-$basearch/")
      end
    end

    context 'with disabled repository installation' do
      let :params do
        {
          :configure_openscap_repo => false
        }
      end

      it 'should not install custom openscap repo' do
        should_not contain_yumrepo("isimluk-openscap")
      end
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
        ':spooldir: /var/spool/foreman-proxy/openscap',
        ':contentdir: /var/lib/foreman-proxy/openscap/content',
        ':reportsdir: /var/lib/foreman-proxy/openscap/reports',
        ':failed_dir: /var/lib/foreman-proxy/openscap/failed',
        ':corrupted_dir: /var/lib/foreman-proxy/openscap/corrupted',
      ])
    end
  end
end
