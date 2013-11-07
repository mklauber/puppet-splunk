# Creates the [script://...] fragments of the splunk inputs.conf file
#
# Based on the inputs.conf.spec.  See at:
# (http://docs.splunk.com/Documentation/Splunk/6.0/admin/Inputsconf)

define splunk::input::script ( $cmd,
  $interval            = undef,
  $passAuth            = undef,
  $queueSize           = undef,
  $persistentQueueSize = undef,
  $index               = undef,
  $start_by_shell      = undef
) {
  include splunk

  # Input Validation
  if $queueSize != undef {
    validate_re($queueSize, '^\d+(KB|MB|GB)$')
  }
  if $persistentQueueSize != undef {
    validate_re($persistentQueueSize, '^\d+(KB|MB|GB|TB)$')
  }
  if $start_by_shell != undef {
    validate_bool($start_by_shell)
  }

  realize Concat['inputs.conf']
  concat::fragment { "script-${title}":
    target  => 'inputs.conf',
    content => template( 'splunk/inputs.conf/script.erb' )
  }
}
