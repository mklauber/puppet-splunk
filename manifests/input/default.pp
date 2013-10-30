define splunk::input::default ( $path, 
  $host       = undef,
  $index      = undef,
  $source     = undef,
  $sourcetype = undef,
  $queue      = undef,
) {
  include splunk

  realize Concat['inputs.conf']
  concat::fragment { 'input-default':
    target  => 'inputs.conf',
    order   => 01,
    content => template( 'splunk/inputs.conf/default.erb' )
  }
}
