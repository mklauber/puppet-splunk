# Creates the [udp://] fragment of the splunk inputs.conf file
#
# Based on the inputs.conf.spec.  See at:
# (http://docs.splunk.com/Documentation/Splunk/6.0/admin/Inputsconf)

define splunk::input::udp ( $port,
  $remote_server          = '',
  $host                   = undef,
  $index                  = undef,
  $source                 = undef,
  $sourcetype             = undef,
  $queue                  = undef,
  $connection_host        = undef,
  $rcvbuf                 = undef,
  $no_priority_stripping  = undef,
  $no_appending_timestamp = undef,
  $queueSize              = undef,
  $persistentQueueSize    = undef,
  $listenOnIPv6           = undef,
  $acceptFrom             = undef
) {
  include splunk

  $_acceptFrom = any2array($acceptFrom)

  # Do field validations
  if $connection_host != undef {
    validate_re($connection_host, '^none$|^ip$|^dns$')
  }
  if $no_priority_stripping != undef {
    validate_bool($no_priority_stripping)
  }
  if $no_appending_timestamp != undef {
    validate_bool($no_appending_timestamp)
  }
  if $queueSize != undef {
    validate_re($queueSize, '^\d+(KB|MB|GB)$')
  }
  if $persistentQueueSize != undef {
    validate_re($persistentQueueSize, '^\d+(KB|MB|GB|TB)$')
  }
  if $listenOnIPv6 != undef {
    validate_re($listenOnIPv6, '^yes$|^no$|^only$')
  }

  realize Concat['inputs.conf']
  concat::fragment { "udp-${title}":
    target  => 'inputs.conf',
    content => template( 'splunk/inputs.conf/udp.erb' )
  }
}
