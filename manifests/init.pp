class splunk {

    service { 'splunk':
        ensure  => running,
        require => Exec['create_service']
    }
}

