require 'spec_helper_acceptance'

describe 'Scenario: install foreman-proxy with http enabled' do
  before(:context) do
    case os[:family]
    when /redhat|fedora/
      on default, puppet('resource package epel-release ensure=present')
      on default, 'yum -y remove foreman* tfm-*'
    when /debian|ubuntu/
      on default, 'apt-get purge -y foreman*', { :acceptable_exit_codes => [0, 100] }
    end
  end

  let(:pp) do
    <<-EOS
    # Workarounds

    ## Ensure repos are present before installing
    Yumrepo <| |> -> Package <| |>

    # Get a certificate from puppet
    exec { 'puppet_server_config-generate_ca_cert':
      creates => '/etc/puppetlabs/puppet/ssl/certs/#{host_inventory['fqdn']}.pem',
      command => '/opt/puppetlabs/bin/puppet ca generate #{host_inventory['fqdn']}',
      umask   => '0022',
    }

    # Actual test
    class { '::foreman_proxy':
      repo                => 'nightly',
      puppet_group        => 'root',
      register_in_foreman => false,
      http                => true,
    }
    EOS
  end

  it_behaves_like 'a idempotent resource'

  describe service('foreman-proxy') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe port(8000) do
    it { is_expected.to be_listening }
  end

  describe port(8443) do
    it { is_expected.to be_listening }
  end
end
