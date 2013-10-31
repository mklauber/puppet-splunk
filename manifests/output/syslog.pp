# Creates the [syslog] and [syslog:...] fragments of the splunk
# outputs.conf file
#
# Based on the outputs.conf.spec.  See at:
# (http://docs.splunk.com/Documentation/Splunk/6.0/admin/Outputsconf)


define splunk::output::syslog ( $server,
  $defaultGroup = undef,
  $target_group = undef,
  #----Common Options----
  $type = undef,
  $priority = undef,
  $syslogSourceType = undef,
  $timestampformat = undef,
) {
  include splunk
  require Package['splunk']

  if ($defaultGroup != undef and $target_group != undef) {
    fail('defaultGroup and target_group cannot both be set.')
  }

  realize Concat['outputs.conf']
  concat::fragment { "syslog-${title}":
    target  => 'outputs.conf',
    order   => 01,
    content => template( 'splunk/outputs.conf/syslog.erb' )
  }
}
