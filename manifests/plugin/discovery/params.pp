# Default parameters for foreman_proxy::plugin::discovery
# @api private
class foreman_proxy::plugin::discovery::params {
  include foreman_proxy::params

  $install_images = false
  $tftp_root      = $foreman_proxy::params::tftp_root
  $source_url     = 'http://downloads.theforeman.org/discovery/releases/latest/'
  $image_name     = 'fdi-image-latest.tar'
}
