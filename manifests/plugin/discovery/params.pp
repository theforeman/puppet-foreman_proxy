# Default parameters for foreman_proxy::plugin::discovery
class foreman_proxy::plugin::discovery::params {
  include ::tftp::params

  $install_images = false
  $tftp_root      = $::tftp::params::root
  $source_url     = 'http://downloads.theforeman.org/discovery/releases/latest/'
  $image_name     = 'fdi-image-latest.tar'
}
