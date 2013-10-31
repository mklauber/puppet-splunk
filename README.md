# mklauber/Splunk

mklauber/splunk is a puppet module for installing and configuring the splunk Server and splunk Universal Forwarder.

It was created by Matthew Lauber.
It is licensed under the Apache 2 License.

## Installation

Installation is done via the standard puppet module command.  `pupppet module install mklauber/splunk`.
Installation can also be done via placing a copy of the module in the `/etc/puppet/modules/` directory.

## Usage 

### Splunk Installation
 
The **splunk server** is installed with the following code: `class { 'splunk::server': }`.
The **splunk Universal Forwarder** is installed with the following code: `class { 'splunk::forwarder': }`.  

### Input and Output Configuration

The Input and Output files for **splunk Server** and **splunk Universal Forwarder** are configured using Resource Definitions.  These definitions can be placed in multiple classes, they will be concatenated and placed in the `${SPLUNK_HOME}/etc/system/local/` directory.

#### Default Input
This creates the `[default]` Stanza in the inputs.conf.  It's always the first stanza if it's specified.  It can only be specified once.

    splunk::input::default { 'title': }

#### Monitor Input

Monitor input creates a `[monitor://{path}]` stanza for each path specified in path.  Multiple monitors can be defined. 
    splunk::input::monitor { 'title':
      path => ['/path/to/log/files']
    }

#### TCP Input

    splunk::input::tcp { 'title':
      port => 9999
    }

#### Syslog Output

    splunk::output::syslog { 'title':
      server => 'syslog.example.com'
    }

#### tcp Output

    splunk::output::tcpout { 'title': }

#### tcpGroup Output

    splunk::output::tcpGroup { 'title':
      target_group => 'Group Name'
    }

#### tcpServer Output

    splunk::output::tcpServer { 'title':
      ip_address => '255.255.255.255',
      port       => 9999
    }


