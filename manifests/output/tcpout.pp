# Creates the Global [tcpout] stanza in splunk's outputs.conf
#
# Based on the outputs.conf.spec.  See at:
# (http://docs.splunk.com/Documentation/Splunk/latest/Admin/Outputsconf)

define splunk::output::tcpout (
  $defaultGroup = undef,
  $indexAndForward = undef,
  #----Common Settings----
  $sendCookedData              = undef,
  $heartbeatFrequency          = undef,
  $blockOnCloning              = undef,
  $compressed                  = undef,
  $negotiateNewProtocol        = undef,
  $channelReapInterval         = undef,
  $channelTTL                  = undef,
  $channelReapLowater          = undef,
  #----Queue Settings----
  $maxQueueSize                = undef,
  $dropEventsOnQueueFull       = undef,
  $dropClonedEventsOnQueueFull = undef,
  $maxFailuresPerInterval      = undef,
  $secsInFailureInterval       = undef,
  $backoffOnFailure            = undef,
  $maxConnectionsPerIndexer    = undef,
  $connectionTimeout           = undef,
  $readTimeout                 = undef,
  $writeTimeout                = undef,
  $dnsResolutionInterval       = undef,
  $forceTimebasedAutoLB        = undef,
  #----Automatic Load-Balancing----
  $autoLB                      = undef,
  $autoLBFrequency             = undef,
  $sslPassword                 = undef,
  $sslCertPath                 = undef,
  $sslRootCAPath               = undef,
  $sslVerifyServerCert         = undef,
  $sslCommonNameToCheck        = undef,
  $sslAltNameToCheck           = undef,
  $useClientSSLCompression     = undef,
  #----Indexer Acknowledgment ----
  $useACK                      = undef
) {
  include splunk

  if $indexAndForward != undef {
    require Package['splunk']
  }

  realize Concat['outputs.conf']
  concat::fragment { 'tcpout':
    target  => 'outputs.conf',
    order   => 01,
    content => template( 'splunk/outputs.conf/tcpout.erb' )
  }
}
