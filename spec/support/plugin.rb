def on_plugin_os
  supported_os = [
    {
      'operatingsystem' => 'RedHat',
      'operatingsystemrelease' => ['8'],
    },
    {
      'operatingsystem' => 'Debian',
      'operatingsystemrelease' => ['11'],
    },
  ]
  on_supported_os(supported_os: supported_os)
end
