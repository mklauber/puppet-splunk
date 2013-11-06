# Creates the [filters://...] fragments of the splunk inputs.conf file
#
# Based on the inputs.conf.spec.  See at:
# (http://docs.splunk.com/Documentation/Splunk/6.0/admin/Inputsconf)

define splunk::input::filter ( $filtertype, $filtername, $regex) {
  include splunk

  $_regex = any2array($regex)

  # Field Validation
  if !($filtertype in ['whitelist', 'blacklist']) {
    fail('filtertype must be in [whitelist|blacklist]')
  }

  realize Concat['inputs.conf']
  concat::fragment { "filter-${title}":
    target  => 'inputs.conf',
    content => template( 'splunk/inputs.conf/filter.erb' )
  }
}
