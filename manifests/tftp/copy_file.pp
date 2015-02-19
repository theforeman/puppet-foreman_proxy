# Copy a TFTP file
define foreman_proxy::tftp::copy_file(
  $target_path,
  $source_file = $title,
) {
  private()
  $filename = inline_template('<%= File.basename(@source_file) %>')
  file {"${target_path}/${filename}":
    ensure => file,
    source => $source_file,
  }
}
