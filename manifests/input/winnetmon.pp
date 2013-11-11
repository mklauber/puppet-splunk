# Creates the [WinNetMon://] fragment of the splunk inputs.conf file
#
# Based on the inputs.conf.spec.  See at:
# (http://docs.splunk.com/Documentation/Splunk/6.0/admin/Inputsconf)

define splunk::input::winnetmon ( $name,
  $remoteAddress        = undef,
  $process              = undef,
  $user                 = undef,
  $addressFamily        = undef,
  $packetType           = undef,
  $direction            = undef,
  $protocol             = undef,
  $readInterval         = undef,
  $driverBufferSize     = undef,
  $userBufferSize       = undef,
  $mode                 = undef,
  $multikvMaxEventCount = undef,
  $multikvMaxTimeMs     = undef,
  $disabled             = undef,
  $index                = undef
) {
  include splunk

  $_addressFamily = any2array($addressFamily)
  $_packetType    = any2array($packetType)
  $_direction     = any2array($direction)
  $_protocol      = any2array($protocol)
  

  # Field Validations
  if $disabled != undef and ($disabled != 0 and $disabled != 1) {
    fail('\$disabled is not in [0|1].')
  }
  if $mode != undef {
    validate_re($mode, '^single$|^multikv$')
  }

  realize Concat['inputs.conf']
  concat::fragment { "winNetMon-${title}":
    target  => 'inputs.conf',
    content => template( 'splunk/inputs.conf/winnetmon.erb' )
  }
}