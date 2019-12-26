def on_plugin_os
  supported_os = [
    {
      'operatingsystem' => 'RedHat',
      'operatingsystemrelease' => ['7'],
    },
    {
      'operatingsystem' => 'Debian',
      'operatingsystemrelease' => ['10'],
    },
  ]
  on_supported_os(supported_os: supported_os)
end
