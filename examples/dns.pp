class { 'foreman_proxy':
  dns         => true,
  dns_zone    => 'example.com',
  dns_reverse => '2.0.192.in-addr.arpa',
}
