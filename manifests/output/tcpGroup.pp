define splunk::output::tcpGroup ( $target_group,
  $server                      = undef,
  $masterUri                   = undef,
  $blockWarnThreshold          = undef,
  
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

  realize Concat['outputs.conf']
  concat::fragment { "tcpGroup-$title":
    target => 'outputs.conf',
    content => template( 'splunk/outputs.conf/tcpGroup.erb' )
  }
}
