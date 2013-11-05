# Create the [indexAndForward] stanza of the splunk outputs.conf file
#
# Based on the outputs.conf.spec.  See at:
# (http://docs.splunk.com/Documentation/Splunk/6.0/admin/Outputsconf)

define splunk::output::indexandforward (
  $index             = undef,
  $selectiveIndexing = undef
) {
  include splunk
  
  if $index != undef {
    validate_bool($index)
  }
  if $selectiveIndexing != undef {
    validate_bool($selectiveIndexing)
  }
  
  realize Concat['outputs.conf']
  concat::fragment { 'indexandforward':
    target  => 'outputs.conf',
    content => template( 'splunk/outputs.conf/indexandforward.erb' )
  }
}