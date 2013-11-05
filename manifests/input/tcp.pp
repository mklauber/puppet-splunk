# Creates the [tcp://] fragment of the splunk inputs.conf file
#
# Based on the inputs.conf.spec.  See at:
# (http://docs.splunk.com/Documentation/Splunk/6.0/admin/Inputsconf)

define splunk::input::tcp ( $port,
  $remote_server       = '',
  $host                = undef,
  $index               = undef,
  $source              = undef,
  $sourcetype          = undef,
  $queue               = undef,
  $connection_host     = undef,
  $queueSize           = undef,
  $persistentQueueSize = undef,
  $requireHeader       = undef,
  $listenOnIPv6        = undef,
  $acceptFrom          = undef,
  $rawTcpDoneTimeout   = undef
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
  if $persistentQueueSize != undef {
    validate_re($persistentQueueSize, '^\d+(KB|MB|GB|TB)$')
  }
  if $listenOnIPv6 != undef {
    validate_re($listenOnIPv6, '^yes$|^no$|^only$')
  }
  
  
  realize Concat['inputs.conf']
  concat::fragment { "tcp-${title}":
    target  => 'inputs.conf',
    content => template( 'splunk/inputs.conf/tcp.erb' )
  }
}

