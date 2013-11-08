# Creates the [splunktcp[://[<remote_server>]:<port>]] fragment of
# the splunk inputs.conf file
#
# Based on the inputs.conf.spec.  See at:
# (http://docs.splunk.com/Documentation/Splunk/6.0/admin/Inputsconf)

define splunk::input::splunktcp (

# Things for [splunktcp]
  $inputShutdownTimeout   = undef,
  $listenOnIPv6           = undef,
  $acceptFrom             = undef,

# Things from [splunktcp://<port>]
  $port                   = undef,
  $remote_server          = '',
  $connection_host        = undef,
  $compressed             = undef,
  $queueSize              = undef,

  # Things for both
  $enableS2SHeartbeat     = undef,
  $s2sHeartbeatTimeout    = undef,
  $negotiateNewProtocol   = undef,
  $concurrentChannelLimit = undef,

) {
  include splunk

  $_acceptFrom = any2array($acceptFrom)

  # Do field validations
  if $connection_host != undef {
    validate_re($connection_host, '^none$|^ip$|^dns$')
  }
  if $queueSize != undef {
    validate_re($queueSize, '^\d+(KB|MB|GB)$')
  }
  if $listenOnIPv6 != undef {
    validate_re($listenOnIPv6, '^yes$|^no$|^only$')
  }
  if $compressed != undef {
    validate_bool($compressed)
  }
  if $enableS2SHeartbeat != undef {
    validate_bool($enableS2SHeartbeat)
  }
  if $negotiateNewProtocol != undef {
    validate_bool($negotiateNewProtocol)
  }

  realize Concat['inputs.conf']
  concat::fragment { "splunktcp-${title}":
    target  => 'inputs.conf',
    content => template( 'splunk/inputs.conf/splunktcp.erb' )
  }
}
