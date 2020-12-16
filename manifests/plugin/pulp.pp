# = Foreman Proxy Pulp plugin
#
# This class installs pulp plugin
#
# === Advanced parameters:
#
# $listen_on::          proxy feature listens on http, https, or both
#
# $version::            plugin package version, it's passed to ensure parameter of package resource
#                       can be set to specific version number, 'latest', 'present' etc.
#
# $pulpcore_enabled::      enables/disables the pulpcore plugin
#
# $pulpcore_mirror::       Whether this pulpcore plugin acts as a mirror or another pulp node. A pulpcore mirror is the pulpcore equivalent of a pulpnode.
#
# $pulpcore_api_url::      The URL to the Pulp 3 API
#
# $pulpcore_content_url::  The URL to the Pulp 3 content
#
class foreman_proxy::plugin::pulp (
  Foreman_proxy::ListenOn $listen_on = 'https',
  Boolean $pulpcore_enabled = true,
  Boolean $pulpcore_mirror = false,
  Stdlib::HTTPUrl $pulpcore_api_url = $foreman_proxy::plugin::pulp::params::pulpcore_api_url,
  Stdlib::HTTPUrl $pulpcore_content_url = $foreman_proxy::plugin::pulp::params::pulpcore_content_url,
  Optional[String] $version = undef,
) inherits foreman_proxy::plugin::pulp::params {

  foreman_proxy::plugin {'pulp':
    version => $version,
  }
  -> [
    foreman_proxy::module { 'pulpcore':
      template_path => 'foreman_proxy/plugin/pulpcore.yml.erb',
      enabled       => $pulpcore_enabled,
      feature       => 'Pulpcore',
      listen_on     => $listen_on,
    },
    # pulp3: removed in rubygem-smart_proxy_pulp 2.0
    # pulp/pulpnode: removed in rubygem-smart_proxy_pulp 3.0
    foreman_proxy::settings_file { ['pulp3', 'pulp', 'pulpnode']:
      ensure        => absent,
    },
  ]
}
