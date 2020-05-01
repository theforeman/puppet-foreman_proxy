def purge_installed_packages
  case os[:family]
  when /redhat|fedora/
    on default, 'yum -y remove foreman* tfm-*'
  when /debian|ubuntu/
    on default, 'apt-get purge -y foreman*', { :acceptable_exit_codes => [0, 100] }
  end
end
