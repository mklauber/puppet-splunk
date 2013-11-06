# Creates the [fifo://] fragment of the splunk inputs.conf file
#
# Based on the inputs.conf.spec.  See at:
# (http://docs.splunk.com/Documentation/Splunk/6.0/admin/Inputsconf)

define splunk::input::fifo ( $path,
  $queueSize           = undef,
  $persistentQueueSize = undef
) {
  include splunk

  # Do field validations
  if $queueSize != undef {
    validate_re($queueSize, '^\d+(KB|MB|GB)$')
  }
  if $persistentQueueSize != undef {
    validate_re($persistentQueueSize, '^\d+(KB|MB|GB|TB)$')
  }

  realize Concat['inputs.conf']
  concat::fragment { "fifo-${title}":
    target  => 'inputs.conf',
    content => template( 'splunk/inputs.conf/fifo.erb' )
  }
}
