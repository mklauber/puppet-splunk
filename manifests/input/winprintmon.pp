# Creates the [WinPrintMon://...] fragments of the splunk inputs.conf file
#
# Based on the inputs.conf.spec.  See at:
# (http://docs.splunk.com/Documentation/Splunk/6.0/admin/Inputsconf)

define splunk::input::winprintmon ( $name,
  $type     = undef,
  $baseline = undef,
  $disabled = undef,
  $index    = undef
) {
  include splunk

  $_path = any2array($path)

  # Field Validations
  if $baseline != undef and ($baseline != 0 and $baseline != 1) {
    fail('\$baseline is not in [0|1].')
  }
  if $disabled != undef and ($disabled != 0 and $disabled != 1) {
    fail('\$disabled is not in [0|1].')
  }

  realize Concat['inputs.conf']
  concat::fragment { "winprintmon-${title}":
    target  => 'inputs.conf',
    content => template( 'splunk/inputs.conf/winprintmon.erb' )
  }
}
