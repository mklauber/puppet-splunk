require 'spec_helper'
describe 'splunk::input::monitor', :type => :define do

  # Define top level variables to use throughout
  concat_file = '/var/lib/puppet/concat/inputs.conf/fragments/10_monitor-default'
  path = '/var/log/path'
  
  # Set some context object the tests depend on
  let(:title) { 'default'}
  let(:facts) {{ :concat_basedir => '/var/lib/puppet/concat', :id => 'root' }}
  let(:params){{ :path => path }}

  # Start the tests
  describe 'When creating a monitor stanza' do
    it {
      should contain_file('inputs.conf')
        .with_path('/opt/splunk/etc/system/local/inputs.conf')
      should contain_file("#{concat_file}")
        .with_content(/[monitor:\/\/#{Regexp.escape(path)}]/)
    }
    context 'without a path' do
      let (:params) {{}}
      it {
        expect {
          should contain_file('#{concat_file}')
        }.to raise_error(Puppet::Error, /Must pass path to Splunk::Input::Monitor\[default\]/)
      }
    end
    context 'with an array of paths' do
      let (:params) {{ :path => ['/var/log/test', '/var/log/test2'] }}
      it {
        should contain_file("#{concat_file}")
          .with_content(/[monitor:\/\/\/var\/log\/test]/)
          .with_content(/[monitor:\/\/\/var\/log\/test2]/)
      }
    end
    context 'with recursive set to false' do
      let(:params) {{ :path => path, :recursive => false }}
      it {
        should contain_file("#{concat_file}").with_content(/recursive = false/m)
      }
    end
    context 'with followSymlink set to false' do
      let(:params) {{ :path => path, :followSymlink => false }}
      it {
        should contain_file("#{concat_file}").with_content(/followSymlink = false/m)
      }
    end
    context 'with all the parameters defined' do
      let(:params){{
        :path               => 'path',
        :host               => 'host',
        :index              => 'index',
        :source             => 'source',
        :sourcetype         => 'sourcetype',
        :queue              => 'queue',
        :host_regex         => 'host_regex',
        :host_segment       => 'host_segment',
        :whitelist          => 'whitelist',
        :blacklist          => 'blacklist',
        :crcSalt            => 'crcSalt',
        :initCrcLength      => 10,
        :ignoreOlderThan    => '10m',
        :followTail         => 0,
        :alwaysOpenFile     => 1,
        :time_before_close  => 12,
        :recursive          => true,
        :followSymlink      => false
      }}
      it {
        should contain_file("#{concat_file}").with_content(/[monitor:\/\/#{Regexp.escape(path)}]/m)
        should contain_file("#{concat_file}").with_content(/host = host/m)
        should contain_file("#{concat_file}").with_content(/index = index/m)
        should contain_file("#{concat_file}").with_content(/source = source/m)
        should contain_file("#{concat_file}").with_content(/sourcetype = sourcetype/m)
        should contain_file("#{concat_file}").with_content(/queue = queue/m)
        should contain_file("#{concat_file}").with_content(/host_regex = host_regex/m)
        should contain_file("#{concat_file}").with_content(/host_segment = host_segment/m)
        should contain_file("#{concat_file}").with_content(/whitelist = whitelist/m)
        should contain_file("#{concat_file}").with_content(/blacklist = blacklist/m)
        should contain_file("#{concat_file}").with_content(/crcSalt = crcSalt/m)
        should contain_file("#{concat_file}").with_content(/initCrcLength = 10/m)
        should contain_file("#{concat_file}").with_content(/ignoreOlderThan = 10m/m)
        should contain_file("#{concat_file}").with_content(/followTail = 0/m)
        should contain_file("#{concat_file}").with_content(/alwaysOpenFile = 1/m)
        should contain_file("#{concat_file}").with_content(/time_before_close = 12/m)
        should contain_file("#{concat_file}").with_content(/recursive = true/m)
        should contain_file("#{concat_file}").with_content(/followSymlink = false/m)
        
      }
    end

  end
end