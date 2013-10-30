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
  $requireHeader        = undef,
  $listenOnIPv6         = undef,
  $acceptFrom           = undef,
  $rawTcpDoneTimeout    = undef
) {
  include splunk

  realize Concat['inputs.conf']
  concat::fragment { "tcp-${title}":
    target  => 'inputs.conf',
    content => template( 'splunk/inputs.conf/tcp.erb' )
  }
}

