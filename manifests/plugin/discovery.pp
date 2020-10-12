# = Foreman Proxy Discovery plugin
#
# Install the discovery plugin and images on smart proxies
#
# === Parameters:
#
# $install_images::   Download and extract the discovery image
#
# === Advanced parameters:
#
# $tftp_root::    TFTP root directory where extracted discovery image will be installed
#
# $source_url::   source URL to download from
#
# $image_name::   tarball with images
#
class foreman_proxy::plugin::discovery (
  Boolean $install_images = $foreman_proxy::plugin::discovery::params::install_images,
  Stdlib::Absolutepath $tftp_root = $foreman_proxy::plugin::discovery::params::tftp_root,
  Stdlib::HTTPUrl $source_url = $foreman_proxy::plugin::discovery::params::source_url,
  String $image_name = $foreman_proxy::plugin::discovery::params::image_name,
) inherits foreman_proxy::plugin::discovery::params {
  foreman_proxy::plugin {'discovery':
  }

  foreman_proxy::feature { 'Discovery': }

  if $install_images {
    $tftp_root_clean = regsubst($tftp_root, '/$', '')

    foreman_proxy::remote_file {"${tftp_root_clean}/boot/${image_name}":
      remote_location => "${source_url}${image_name}",
      mode            => '0644',
    } ~> exec { "untar ${image_name}":
      command => "tar xf ${image_name}",
      path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      cwd     => "${tftp_root_clean}/boot",
      creates => "${tftp_root_clean}/boot/fdi-image/initrd0.img",
    }
  }
}
