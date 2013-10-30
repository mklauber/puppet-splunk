# = ClassL splunk::forwarder
#
# This class manages the installation of the splunk Universal Forwarder.
# All input and output configuration is managed by Defined Resource Types. 
#
# == Parameters
# 

class splunk::forwarder ( $basedir='/opt/splunkforwarder') {
 
  include splunk 
  package { 'splunkforwarder':
    ensure => present
  }
  service { 'splunk':
    ensure  => running,
    require => Exec['create_service']
  }

  exec { 'create_service':
    command  => "${basedir}/bin/splunk enable boot-start --accept-license --answer-yes --no-prompt",
    creates  => '/etc/init.d/splunk',
    require  => Package['splunkforwarder'],
  }
  
  @concat { 'inputs.conf':
    path => "${splunk::forwarder::basedir}/etc/system/local/inputs.conf",
    notify => Service['splunk']
  }
  @concat { 'outputs.conf':
    path => "${splunk::forwarder::basedir}/etc/system/local/outputs.conf",
    notify => Service['splunk']
  }
  @concat { 'props.conf':
    path => "${splunk::forwarder::basedir}/etc/system/local/props.conf",
    notify => Service['splunk']
  }
}
