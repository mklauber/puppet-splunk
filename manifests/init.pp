# Top level splunk class
#
# This class will be used for all shared aspects of the server and forwarder
class splunk {

  $basedir = '/opt/splunk'

  service { 'splunk':
    ensure  => running,
    require => Exec['splunk_service']
  }
  @concat { 'inputs.conf':
    path   => "${basedir}/etc/system/local/inputs.conf",
    notify => Service['splunk']
  }
  @concat { 'outputs.conf':
    path   => "${basedir}/etc/system/local/outputs.conf",
    notify => Service['splunk']
  }
  @concat { 'props.conf':
    path   => "${basedir}/etc/system/local/props.conf",
    notify => Service['splunk']
  }
}

