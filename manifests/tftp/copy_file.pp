# Copy a TFTP file
#
# Private defined type, not for external use.
define foreman_proxy::tftp::copy_file(
  $target_path,
  $source_file = $title,
) {
  $filename = inline_template('<%= File.basename(@source_file) %>')
  file {"${target_path}/${filename}":
    ensure => file,
    source => $source_file,
  }
}
