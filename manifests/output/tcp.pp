define splunk::output::tcpout ( 
  $defaultGroup = undef,
  $indexAndForward = undef,
  
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
  
  if $indexAndForward != undef
    require Package['splunk']
  end
  
  

  realize Concat['outputs.conf']
  concat::fragment { "tcpout":
    target  => 'outputs.conf',
    order   => 01,
    content => template( 'splunk/outputs.conf/tcp.erb' )
  }
}
