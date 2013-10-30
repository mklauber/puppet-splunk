define splunk::output::syslog ( $server,
  $defaultGroup = undef,
  $target_group = undef,
  
  $type = undef,
  $priority = undef,
  $syslogSourceType = undef,
  $timestampformat = undef,
) {
  include splunk
  require Package['splunk']

  if $defaultGroup != undef && $target_group != undef
    fail("defaultGroup and target_group cannot both be set.")
  end
  
  realize Concat['outputs.conf']
  concat::fragment { "tcpout":
    target  => 'outputs.conf',
    order   => 01,
    content => template( 'splunk/outputs.conf/tcp.erb' )
  }
}
