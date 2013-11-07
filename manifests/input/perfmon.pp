# Creates the [perfmon://...] fragments of the splunk inputs.conf file
#
# Based on the inputs.conf.spec.  See at:
# (http://docs.splunk.com/Documentation/Splunk/6.0/admin/Inputsconf)

define splunk::input::perfmon ( $name, $object, $counters,
  $instances        = undef,
  $interval         = undef,
  $mode             = undef,
  $samplingInterval = undef,
  $stats            = undef,
  $disabled         = undef,
  $index            = undef,
  $showZeroValue    = undef
) {
  include splunk

  $_counters = any2array($counters)
  $_instances = any2array($instances)
  $_stats= any2array($stats)

  # Field Validations
  if $mode != undef and !($mode in ['single', 'multikv']) {
    fail('\$mode is not in [single|multikv]')
  }

  if $disabled != undef and ($disabled != 0 and $disabled != 1) {
    fail('\$disabled is not in [0|1].')
  }
  if $showZeroValue != undef and ($showZeroValue != 0 and $showZeroValue != 1) {
    fail('\$showZeroValue is not in [0|1].')
  }

  realize Concat['inputs.conf']
  concat::fragment { "perfmon-${title}":
    target  => 'inputs.conf',
    content => template( 'splunk/inputs.conf/perfmon.erb' )
  }
}
