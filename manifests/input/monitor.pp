# Creates the [monitor://...] fragments of the splunk inputs.conf file
#
# Based on the inputs.conf.spec.  See at:
# (http://docs.splunk.com/Documentation/Splunk/6.0/admin/Inputsconf)

define splunk::input::monitor ( $path,
  $host               = undef,
  $index              = undef,
  $source             = undef,
  $sourcetype         = undef,
  $queue              = undef,
  $host_regex         = undef,
  $host_segment       = undef,
  $whitelist          = undef,
  $blacklist          = undef,
  $crcSalt            = undef,
  $initCrcLength      = undef,
  $ignoreOlderThan    = undef,
  $followTail         = undef,
  $alwaysOpenFile     = undef,
  $time_before_close  = undef,
  $recursive          = undef,
  $followSymlink      = undef
) {
  include splunk

  $paths = any2array($path)

  realize Concat['inputs.conf']
  concat::fragment { "monitor-${title}":
    target  => 'inputs.conf',
    content => template( 'splunk/inputs.conf/monitor.erb' )
  }
}
