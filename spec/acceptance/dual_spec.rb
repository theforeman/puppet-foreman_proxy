require 'spec_helper_acceptance'

describe 'Scenario: install foreman-proxy with http and https enabled' do
  before(:context) do
    case os[:family]
    when /redhat|fedora/
      on default, 'yum -y remove foreman* tfm-*'
    when /debian|ubuntu/
      on default, 'apt-get purge -y foreman*', { :acceptable_exit_codes => [0, 100] }
    end
  end

  let(:pp) do
    <<-EOS
    $directory = '/etc/foreman-proxy'
    $certificate = "${directory}/certificate.pem"
    $key = "/etc/foreman-proxy/key.pem"
    exec { 'Create certificate directory':
      command => "mkdir -p ${directory}",
      path    => ['/bin', '/usr/bin'],
      creates => $directory,
    } ->
    exec { 'Generate certificate':
      command => "openssl req -nodes -x509 -newkey rsa:2048 -subj '/CN=${facts['fqdn']}' -keyout '${key}' -out '${certificate}' -days 365",
      path    => ['/bin', '/usr/bin'],
      creates => $certificate,
      umask   => '0022',
    } ->
    file { [$key, $certificate]:
      owner => $foreman_proxy::user,
      group => $foreman_proxy::user,
      mode  => '0640',
    } ->
    class { 'foreman_proxy':
      repo                => 'nightly',
      puppet_group        => 'root',
      register_in_foreman => false,
      ssl_ca              => $certificate,
      ssl_cert            => $certificate,
      ssl_key             => $key,
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
