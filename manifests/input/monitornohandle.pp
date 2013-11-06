# Creates the [MonitorNoHandle://...] fragments of the splunk inputs.conf file
#
# Based on the inputs.conf.spec.  See at:
# (http://docs.splunk.com/Documentation/Splunk/6.0/admin/Inputsconf)

define splunk::input::monitornohandle ( $path,
  $index    = undef,
  $disabled = undef
) {
  include splunk

  # Field Validation
  if $disabled != undef and ($disabled != 0 and $disabled != 1) {
    fail('\$disabled is not in [0|1].')
  }

  realize Concat['inputs.conf']
  concat::fragment { "monitornohandle-${title}":
    target  => 'inputs.conf',
    content => template( 'splunk/inputs.conf/monitornohandle.erb' )
  }
}