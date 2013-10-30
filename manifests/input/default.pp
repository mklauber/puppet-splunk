# Creates the [default] fragment of the splunk inputs.conf file
#
# Based on the inputs.conf.spec.  See at:
# (http://docs.splunk.com/Documentation/Splunk/6.0/admin/Inputsconf)
define splunk::input::default (
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
