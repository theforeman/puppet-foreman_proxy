# @summary Downloads a file from a URL to a local file given by the title
# @api private
define foreman_proxy::remote_file (
  Stdlib::Filesource $remote_location,
  Stdlib::Filemode $mode = '0644',
  Optional[String[1]] $owner = undef,
  Optional[String[1]] $group = undef,
) {
  $parent = dirname($title)
  File <| title == $parent |>
  -> exec { "mkdir -p ${parent}":
    path    => ['/bin', '/usr/bin'],
    creates => $parent,
  }
  -> file { $title:
    source  => $remote_location,
    mode    => $mode,
    owner   => $owner,
    group   => $group,
    replace => false,
  }
}
