# @api private
#
# This class is called from tang for service config.
#
class tang::config (
  Optional[Integer[1,65536]] $listen_port = undef,
) {
  assert_private('tang::config is a private class')
  include tang

  if $listen_port {
    systemd::dropin_file { "Make Tang listen on poort ${listen_port}":
      filename => 'override.conf',
      unit     => $tang::service_name,
      content  => "[Socket]\nListenStream=\nListenStream=${listen_port}",
    }

    selinux::port { "Allow Tang to listen on port ${listen_port}":
      seltype  => 'tangd_port_t',
      protocol => 'tcp',
      port     => $listen_port,
    }
  } else {
    systemd::dropin_file { "Make Tang listen on poort ${listen_port}":
      ensure   => absent,
      filename => 'override.conf',
      unit     => $tang::service_name,
    }
  }
}
