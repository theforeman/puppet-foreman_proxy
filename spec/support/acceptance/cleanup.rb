def purge_foreman_proxy
  case os[:family]
  when /redhat|fedora/
    on default, 'yum -y remove foreman* tfm-* mosquitto'
  when /debian|ubuntu/
    on default, 'apt-get purge -y foreman* mosquitto', { :acceptable_exit_codes => [0, 100] }
  end
  on default, 'rm -rf /etc/mosquitto/'
end
