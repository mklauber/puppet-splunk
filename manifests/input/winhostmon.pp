# Creates the [WinHostMon://] fragment of the splunk inputs.conf file
#
# Based on the inputs.conf.spec.  See at:
# (http://docs.splunk.com/Documentation/Splunk/6.0/admin/Inputsconf)

define splunk::input::winhostmon ( $name,
  $type     = undef,
  $interval = undef,
  $disabled = undef,
  $index    = undef
) {
  include splunk

  $_type = any2array($type)

  # Field Validations
  if $disabled != undef and ($disabled != 0 and $disabled != 1) {
    fail('\$disabled is not in [0|1].')
  }

  realize Concat['inputs.conf']
  concat::fragment { "winHostMon-${title}":
    target  => 'inputs.conf',
    content => template( 'splunk/inputs.conf/winhostmon.erb' )
  }
}