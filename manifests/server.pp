# = Class splunk::server
#
# This class manages the installation of the splunk Server.
# All input and output configuration is managed by Defined Resource Types.
#
# == Parameters
#

class splunk::server ( $basedir='/opt/splunk') inherits splunk {

  package { 'splunk':
    ensure => present,
    before => Exec['create_service']
  }

  exec { 'create_service':
    command  => "${basedir}/bin/splunk enable boot-start --accept-license --answer-yes --no-prompt",
    creates  => '/etc/init.d/splunk',
  }

  Concat ['inputs.conf'] {
    path   => "${basedir}/etc/system/local/inputs.conf",
  }
  Concat ['outputs.conf'] {
    path   => "${basedir}/etc/system/local/outputs.conf",
  }
  Concat ['props.conf'] {
    path   => "${basedir}/etc/system/local/props.conf",
  }
}

