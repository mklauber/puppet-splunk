# Creates the [tcp-ssl:<port>] fragment of the splunk inputs.conf file
#
# Based on the inputs.conf.spec.  See at:
# (http://docs.splunk.com/Documentation/Splunk/6.0/admin/Inputsconf)

define splunk::input::tcpssl ( $port,
  $listenOnIPv6        = undef,
  $acceptFrom          = undef
) {
  include splunk

  $_acceptFrom = any2array($acceptFrom)

  # Do field validations
  if $listenOnIPv6 != undef {
    validate_re($listenOnIPv6, '^yes$|^no$|^only$')
  }

  realize Concat['inputs.conf']
  concat::fragment { "tcpssl-${title}":
    target  => 'inputs.conf',
    content => template( 'splunk/inputs.conf/tcpssl.erb' )
  }
}
