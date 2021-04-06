# @summary Install the Amazon Route53 DNS plugin for Foreman proxy
#
# @param aws_access_key
#   The Access Key ID of the IAM account
#
# @param aws_secret_key
#   The Secret Access Key of the IAM account
#
class foreman_proxy::plugin::dns::route53 (
  String $aws_access_key,
  String $aws_secret_key,
) {
  foreman_proxy::plugin::provider { 'dns_route53':
  }
}
