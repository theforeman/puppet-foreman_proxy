def tftp_root
  case host_inventory['facter']['os']['name']
  when 'Debian', 'Ubuntu'
    '/srv/tftp'
  else
    '/var/lib/tftpboot'
  end
end
