# Creates the [WinEventLog://] fragment of the splunk inputs.conf file
#
# Based on the inputs.conf.spec.  See at:
# (http://docs.splunk.com/Documentation/Splunk/6.0/admin/Inputsconf)

define splunk::input::wineventlog ( $name,
  $start_from         = undef,
  $current_only       = undef,
  $checkpointInterval = undef,
  $disabled           = undef,
  $evt_resolve_ad_obj = undef,
  $evt_dc_name        = undef,
  $evt_dns_name       = undef,
  $index              = undef,
  $whitelist          = undef,
  $blacklist          = undef,
  $suppress_text      = undef
) {
  include splunk

  $_whitelist = any2array($whitelist)
  $_blacklist = any2array($blacklist)

  # Field Validations
  if $current_only != undef and ($current_only != 0 and $current_only != 1) {
    fail('\$current_only is not in [0|1].')
  }
  if $disabled != undef and ($disabled != 0 and $disabled != 1) {
    fail('\$disabled is not in [0|1].')
  }
  if $evt_resolve_ad_obj != undef and ($evt_resolve_ad_obj != 0 and $evt_resolve_ad_obj != 1) {
    fail('\$evt_resolve_ad_obj is not in [0|1].')
  }
  if $suppress_text != undef and ($suppress_text != 0 and $suppress_text != 1) {
    fail('\$suppress_text is not in [0|1].')
  }

  realize Concat['inputs.conf']
  concat::fragment { "winEventLog-${title}":
    target  => 'inputs.conf',
    content => template( 'splunk/inputs.conf/wineventlog.erb' )
  }
}