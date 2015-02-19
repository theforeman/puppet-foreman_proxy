# Sync a TFTP file
# TODO: remove on the next major version bump
define foreman_proxy::tftp::sync_file(
  $source_path,
  $target_path
) {
  warning('foreman_proxy::tftp::sync_file is deprecated and will be removed')

  file {"${target_path}/${name}":
    ensure => file,
    source => "${source_path}/${name}",
  }

}
