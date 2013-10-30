# = Class splunk::server
#
# This class manages the installation of the splunk Server.
# All input and output configuration is managed by Defined Resource Types. 
#
# == Parameters
# 

class splunk::server ( $basedir='/opt/splunk') {
 
  include splunk 
  package { 'splunk':
    ensure => present,
    before => Exec['create_service']
  }

  exec { 'create_service':
    command  => "${basedir}/bin/splunk enable boot-start --accept-license --answer-yes --no-prompt",
    creates  => '/etc/init.d/splunk',
  }
  

  @concat { 'inputs.conf':
    path => "${basedir}/etc/system/local/inputs.conf",
    notify => Service['splunk']
  }
  @concat { 'outputs.conf':
    path => "${basedir}/etc/system/local/outputs.conf",
    notify => Service['splunk']
  }
  @concat { 'props.conf':
    path => "${basedir}/etc/system/local/props.conf",
    notify => Service['splunk']
  }
}

