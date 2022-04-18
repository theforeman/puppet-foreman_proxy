# The possible openssh LogLevel values. Note that these are values allowed by the
# smart_proxy_remote_execution_ssh gem and are not consistent with the ssh_config(5) man page.
type Foreman_proxy::Sshloglevel = Enum['debug', 'info', 'error', 'fatal']
