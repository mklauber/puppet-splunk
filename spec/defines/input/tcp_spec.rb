require 'spec_helper'
describe 'splunk::input::tcp', :type => :define do

  # Define top level variables to use throughout
  concat_file = '/var/lib/puppet/concat/inputs.conf/fragments/10_tcp-default'
  port = 9999
  
  # Set some context object the tests depend on
  let(:title) { 'default'}
  let(:facts) {{ :concat_basedir => '/var/lib/puppet/concat', :id => 'root' }}
  let(:params){{ :port => port }}

  # Start the tests
  describe 'When creating a tcp stanza' do
    it {
      should contain_file('inputs.conf')
        .with_path('/opt/splunk/etc/system/local/inputs.conf')
      should contain_file("#{concat_file}")
        .with_content(/[tcp:\/\/:#{port}]/)
    }
    context 'without a port' do
    let (:params) {{}}
    it {
      expect {
        should contain_file('#{concat_file}')
      }.to raise_error(Puppet::Error, /Must pass port to Splunk::Input::Tcp\[default\]/)
    }
  end
    context 'with $remote_server defined' do
      let (:params) {{ :port => port, :remote_server => 'example.com' }}
      it {
        should contain_file("#{concat_file}").with_content(/[tcp:\/\/example.com:#{port}]/m)
      }
    end
    context 'with connection_host ' do
      context 'set' do
        ['none', 'ip', 'dns'].each do |size|
          let (:params) {{:port => port, :connection_host => size }}
          it {
            should contain_file("#{concat_file}").with_content(/[connection_host = #{size}]/m)
          }
        end
      end
      context 'not in [ip|dns|none]' do
        let (:params) {{:port => port, :connection_host => 'bad_input'}}
        it {
          expect {
            should contain_file('#{concat_file}')
          }.to raise_error(Puppet::Error, /\"bad_input\" does not match \"\^none\$\|\^ip\$\|\^dns\$\"/)
        }
      end
    end
    context 'with queueSize' do
      context 'in KB, MB, or GB' do
        ['10KB', '20KB', '11MB', '21MB', '12GB', '22GB'].each do |size|
          let (:params) {{:port => port, :queueSize => size }}
          it {
            should contain_file("#{concat_file}").with_content(/[queueSize = #{size}]/m)
          }          
        end
      end
      context 'not in [<integer>KB|MB|GB]' do
        let (:params) {{:port => port, :queueSize => 'bad_input'}}
        it {
          expect {
            should contain_file('#{concat_file}')
          }.to raise_error(Puppet::Error, /\"bad_input\" does not match \"\^\\\\d\+\(KB\|MB\|GB\)\$\"/)
        }
      end
    end
    context 'with persistentQueueSize' do
      context 'in KB, MB, or GB' do
        ['10KB', '20KB', '11MB', '21MB', '12GB', '22GB', '13TB', '23TB'].each do |size|
          let (:params) {{:port => port, :persistentQueueSize => size }}
          it {
            should contain_file("#{concat_file}").with_content(/[persistentQueueSize = #{size}]/m)
          }          
        end
      end
      context 'not in [<integer>KB|MB|GB]' do
        let (:params) {{:port => port, :persistentQueueSize => 'bad_input'}}
        it {
          expect {
            should contain_file('#{concat_file}')
          }.to raise_error(Puppet::Error, /\"bad_input\" does not match \"\^\\\\d\+\(KB\|MB\|GB\|TB\)\$\"/)
        }
      end
    end
    context 'with listenOnIPv6 ' do
      context 'set' do
        ['yes', 'no', 'only'].each do |size|
          let (:params) {{:port => port, :listenOnIPv6 => size }}
          it {
            should contain_file("#{concat_file}").with_content(/[listenOnIPv6 = #{size}]/m)
          }
        end
      end
      context 'not in [yes|no|only]' do
        let (:params) {{:port => port, :listenOnIPv6 => 'bad_input'}}
        it {
          expect {
            should contain_file('#{concat_file}')
          }.to raise_error(Puppet::Error, /\"bad_input\" does not match \"\^yes\$\|\^no\$\|\^only\$\"/)
        }
      end
    end
    context 'with $acceptFrom set' do
      context 'to a single string' do
        let (:params) {{ :port => port, :acceptFrom => 'example.com' }}
        it {
          should contain_file("#{concat_file}").with_content(/acceptFrom = example\.com/m)
        }
      end
      context 'to an array' do
        let (:params) {{ :port => port, :acceptFrom => ['example.com', '10.0.2.3'] }}
        it {
          should contain_file("#{concat_file}").with_content(/acceptFrom = example\.com, 10\.0\.2\.3/m)
        }
      end
    end
    context 'with all the parameters defined' do
      let(:params){{
        :port                => port,
        :remote_server       => 'remote.server',
        :host                => 'host',
        :index               => 'index',
        :source              => 'source',
        :sourcetype          => 'sourcetype',
        :queue               => 'queue',
        :connection_host     => 'none',
        :queueSize           => '10KB',
        :persistentQueueSize => '10TB',
        :requireHeader       => true,
        :listenOnIPv6        => 'only',
        :acceptFrom          => '10.0.2.3',
        :rawTcpDoneTimeout    => 10
      }}
      it {
        should contain_file("#{concat_file}").with_content(/[tcp:\/\/remote\.server:#{port}]/m)
        should contain_file("#{concat_file}").with_content(/host = host/m)
        should contain_file("#{concat_file}").with_content(/index = index/m)
        should contain_file("#{concat_file}").with_content(/source = source/m)
        should contain_file("#{concat_file}").with_content(/sourcetype = sourcetype/m)
        should contain_file("#{concat_file}").with_content(/queue = queue/m)
        should contain_file("#{concat_file}").with_content(/connection_host = none/m)
        should contain_file("#{concat_file}").with_content(/queueSize = 10KB/m)
        should contain_file("#{concat_file}").with_content(/persistentQueueSize = 10TB/m)
        should contain_file("#{concat_file}").with_content(/requireHeader = true/m)
        should contain_file("#{concat_file}").with_content(/listenOnIPv6 = only/m)
        should contain_file("#{concat_file}").with_content(/acceptFrom = 10.0.2.3/m)
        should contain_file("#{concat_file}").with_content(/rawTcpDoneTimeout = 10/m)
      }
    end

  end
end