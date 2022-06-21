# @summary Downloads a file from a URL to a local file given by the title
# @api private
define foreman_proxy::remote_file (
  $remote_location,
  $mode='0644',
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
    replace => false,
  }
}
