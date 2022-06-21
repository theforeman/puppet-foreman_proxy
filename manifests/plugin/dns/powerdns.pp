# @summary Install the PowerDNS DNS plugin for Foreman proxy
#
# @param rest_url
#   The REST API URL
#
# @param rest_api_key
#   The REST API key
#
class foreman_proxy::plugin::dns::powerdns (
  String $rest_api_key,
  Stdlib::HTTPUrl $rest_url = 'http://localhost:8081/api/v1/servers/localhost',
) {
  foreman_proxy::plugin::provider { 'dns_powerdns':
  }
}
