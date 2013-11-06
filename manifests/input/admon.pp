# Creates the [AdMon://...] fragments of the splunk inputs.conf file
#
# Based on the inputs.conf.spec.  See at:
# (http://docs.splunk.com/Documentation/Splunk/6.0/admin/Inputsconf)

define splunk::input::admon ( $name,
  $targetDc       = undef,
  $startingNode   = undef,
  $monitorSubtree = undef,
  $disabled       = undef,
  $index          = undef,
  $printSchema    = undef,
  $baseline       = undef
) {
  include splunk

  # Field Validations
  if $monitorSubtree != undef and ($monitorSubtree != 0 and $monitorSubtree != 1) {
    fail('\$monitorSubtree is not in [0|1].')
  }
  if $printSchema != undef and ($printSchema != 0 and $printSchema != 1) {
    fail('\$printSchema is not in [0|1].')
  }
  if $disabled != undef and ($disabled != 0 and $disabled != 1) {
    fail('\$disabled is not in [0|1].')
  }
  if $baseline != undef and ($baseline != 0 and $baseline != 1) {
    fail('\$baseline is not in [0|1].')
  }

  realize Concat['inputs.conf']
  concat::fragment { "admon-${title}":
    target  => 'inputs.conf',
    content => template( 'splunk/inputs.conf/admon.erb' )
  }
}
