# Top level splunk class
#
# This class will be used for all shared aspects of the server and forwarder
class splunk {

    service { 'splunk':
        ensure  => running,
        require => Exec['create_service']
    }
}

