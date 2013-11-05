# Creates the [default] fragment of the splunk inputs.conf file
#
# Based on the inputs.conf.spec.  See at:
# (http://docs.splunk.com/Documentation/Splunk/6.0/admin/Inputsconf)
define splunk::input::batch ( $path,
  $host          = undef,
  $index         = undef,
  $sourcetype    = undef,
  $queue         = undef,
  $host_regex    = undef,
  $host_segment  = undef,
  $recursive     = undef,
  $whitelist     = undef,
  $blacklist     = undef,
  $crcSalt       = undef,
  $initCrcLength = undef,
  $followSymlink = undef,
) {
  include splunk

  # Field Validation
  if $recursive != undef {
    validate_bool($recursive)
  }
  if $followSymlink != undef {
    validate_bool($followSymlink)
  }

  realize Concat['inputs.conf']
  concat::fragment { "batch-${title}":
    target  => 'inputs.conf',
    content => template( 'splunk/inputs.conf/batch.erb' )
  }
}
