# Creates the [WinRegMon://] fragment of the splunk inputs.conf file
#
# Based on the inputs.conf.spec.  See at:
# (http://docs.splunk.com/Documentation/Splunk/6.0/admin/Inputsconf)

define splunk::input::winregmon ( $name,
  $proc              = undef,
  $hive              = undef,
  $type              = undef,
  $baseline          = undef,
  $baseline_interval = undef,
  $disabled          = undef,
  $index             = undef
) {
  include splunk

  # Field Validations
  if $baseline != undef and ($baseline != 0 and $baseline != 1) {
    fail('\$baseline is not in [0|1].')
  }
  if $disabled != undef and ($disabled != 0 and $disabled != 1) {
    fail('\$disabled is not in [0|1].')
  }

  realize Concat['inputs.conf']
  concat::fragment { "winRegMon-${title}":
    target  => 'inputs.conf',
    content => template( 'splunk/inputs.conf/winregmon.erb' )
  }
}