# = ClassL splunk::forwarder
#
# This class manages the installation of the splunk Universal Forwarder.
# All input and output configuration is managed by Defined Resource Types. 
#
# == Parameters
# 

class splunk::forwarder ( $basedir='/opt/splunkforwarder')
  include splunk
  
  package { 'splunkforwarder':
    ensure => present
  }
  service { 'splunk':
    ensure  => present,
    require => Package['splunkforwarder']
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
end
