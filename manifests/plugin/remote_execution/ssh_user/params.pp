# Remote Execution SSH user default parameters
# @api private
class foreman_proxy::plugin::remote_execution::ssh_user::params {
  # `getvar()` is used because the top scope variables being accessed here are *not* facts.
  # They come from the ENC, (foreman), and are not present in `$facts`.
  # `$::var` can't safely be used either as catalog compilation will fail if `strict_variables = true`
  # and the ENC isn't sending these parameters.

  $manage_user = str2bool(pick(getvar('remote_execution_create_user'),false))

  $ssh_user = pick(getvar('remote_execution_ssh_user'),'root')

  $effective_user_method = pick(getvar('remote_execution_effective_user_method'),'sudo')

  $ssh_keys = getvar('remote_execution_ssh_keys') ? {
    Array   => getvar('remote_execution_ssh_keys'),
    default => [],
  }
}
