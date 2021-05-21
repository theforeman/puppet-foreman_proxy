# Install a proxy with HTTPBoot
# Note DHCP is not strictly needed, but this is enabled to test as much
# functionality as possible.
class { 'foreman_proxy':
  http     => true,
  httpboot => true,
  tftp     => true,
  dhcp     => true,
}
