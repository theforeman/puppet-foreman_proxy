# Register the foreman proxy
class foreman_proxy::register {

  if $foreman_proxy::register_in_foreman {
    foreman_smartproxy { $foreman_proxy::registered_name:
      ensure          => present,
      base_url        => $foreman_proxy::foreman_base_url,
      consumer_key    => $foreman_proxy::oauth_consumer_key,
      consumer_secret => $foreman_proxy::oauth_consumer_secret,
      effective_user  => $foreman_proxy::oauth_effective_user,
      ssl_ca          => pick($foreman_proxy::foreman_ssl_ca, $foreman_proxy::ssl_ca),
      url             => $foreman_proxy::real_registered_proxy_url,
    }
  }

}
