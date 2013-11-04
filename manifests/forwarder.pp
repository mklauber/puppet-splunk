# = Class splunk::forwarder
#
# This class manages the installation of the splunk Universal Forwarder.
# All input and output configuration is managed by Defined Resource Types.
#
# == Parameters
#
# * $basedir - Root director of the splunkforwarder installation.

class splunk::forwarder($basedir='/opt/splunkforwarder') inherits splunk{

  package { 'splunkforwarder':
    ensure => present,
    before => Exec['splunk_service']
  }

  exec { 'splunk_service':
    command  => "${basedir}/bin/splunk enable boot-start --accept-license --answer-yes --no-prompt",
    creates  => '/etc/init.d/splunk',
  }

  Concat['inputs.conf'] {
    path   => "${basedir}/etc/system/local/inputs.conf",
  }
  Concat['outputs.conf'] {
    path   => "${basedir}/etc/system/local/outputs.conf",
  }
  Concat['props.conf'] {
    path   => "${basedir}/etc/system/local/props.conf",
  }
}
