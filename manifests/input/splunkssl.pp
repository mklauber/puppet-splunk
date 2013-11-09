# Creates the [splunktcp-ssl:<port>] fragment of the splunk inputs.conf file
#
# Based on the inputs.conf.spec.  See at:
# (http://docs.splunk.com/Documentation/Splunk/6.0/admin/Inputsconf)

define splunk::input::splunkssl ( $port,
  $connection_host        = undef,
  $enableS2SHeartbeat     = undef,
  $s2sHeartbeatTimeout    = undef,
  $listenOnIPv6           = undef,
  $acceptFrom             = undef,
  $negotiateNewProtocol   = undef,
  $concurrentChannelLimit = undef,
) {
  include splunk

  $_acceptFrom = any2array($acceptFrom)

  # Do field validations
  if $connection_host != undef {
    validate_re($connection_host, '^none$|^ip$|^dns$')
  }
  if $listenOnIPv6 != undef {
    validate_re($listenOnIPv6, '^yes$|^no$|^only$')
  }
  if $enableS2SHeartbeat != undef {
    validate_bool($enableS2SHeartbeat)
  }
  if $negotiateNewProtocol != undef {
    validate_bool($negotiateNewProtocol)
  }

  realize Concat['inputs.conf']
  concat::fragment { "splunkssl-${title}":
    target  => 'inputs.conf',
    content => template( 'splunk/inputs.conf/splunkssl.erb' )
  }
}
