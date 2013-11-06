# Creates the [fschange:...] fragments of the splunk inputs.conf file
#
# Based on the inputs.conf.spec.  See at:
# (http://docs.splunk.com/Documentation/Splunk/6.0/admin/Inputsconf)

define splunk::input::fschange ( $path,
  $index            = undef,
  $signedaudit      = undef,
  $filters          = undef,
  $recurse          = undef,
  $followLinks      = undef,
  $pollPeriod       = undef,
  $hashMaxSize      = undef,
  $fullEvent        = undef,
  $sendEventMaxSize = undef,
  $sourcetype       = undef,
  $host             = undef,
  $filesPerDelay    = undef,
  $delayInMills     = undef
) {
  include splunk

  $_filters = any2array($filters)

  # Field Validation
  if $signedaudit != undef {
    validate_bool($signedaudit)
  }
  if $recurse != undef {
    validate_bool($recurse)
  }
  if $followLinks != undef {
    validate_bool($followLinks)
  }
  if $fullEvent != undef {
    validate_bool($fullEvent)
  }

  realize Concat['inputs.conf']
  concat::fragment { "fschange-${title}":
    target  => 'inputs.conf',
    content => template( 'splunk/inputs.conf/fschange.erb' )
  }
}