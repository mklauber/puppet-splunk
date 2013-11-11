require 'spec_helper'
describe 'splunk::input::splunktcp', :type => :define do

  # Define top level variables to use throughout
  concat_file = '/var/lib/puppet/concat/inputs.conf/fragments/10_splunktcp-default'
  port = 9999
  
  # Set some context object the tests depend on
  let(:title) { 'default'}
  let(:facts) {{ :concat_basedir => '/var/lib/puppet/concat', :id => 'root' }}

  # Start the tests
  describe 'When creating a tcp stanza' do
    context 'without a port' do
      it {
        should contain_file('inputs.conf').with_path('/opt/splunk/etc/system/local/inputs.conf')
        should contain_file(concat_file).with_content(/\[splunktcp\]/)
      }
    end
    context 'with a port' do
      let(:params){{ :port => port }}
      it {
        should contain_file('inputs.conf').with_path('/opt/splunk/etc/system/local/inputs.conf')
        should contain_file(concat_file).with_content(/\[splunktcp:\/\/:#{port}\]/)
      }
    end
    context 'with $remote_server defined' do
      let (:params) {{ :port => port, :remote_server => 'example.com' }}
      it {
        should contain_file(concat_file).with_content(/\[splunktcp:\/\/example.com:#{port}\]/m)
      }
    end
    context 'with connection_host ' do
      ['none', 'ip', 'dns'].each do |size|
        context 'set to #{size}' do
          let (:params) {{:port => port, :connection_host => size }}
          it {
            should contain_file(concat_file).with_content(/connection_host = #{size}/m)
          }
        end
      end
      context 'not in [ip|dns|none]' do
        let (:params) {{:port => port, :connection_host => 'bad_input'}}
        it {
          expect {
            should contain_file(concat_file)
          }.to raise_error(Puppet::Error, /\"bad_input\" does not match \"\^none\$\|\^ip\$\|\^dns\$\"/)
        }
      end
    end
    context 'with queueSize' do
      ['10KB', '20KB', '11MB', '21MB', '12GB', '22GB'].each do |size|
        context 'set to #{size}' do
          let (:params) {{:port => port, :queueSize => size }}
          it {
            should contain_file(concat_file).with_content(/queueSize = #{size}/m)
          }          
        end
      end
      context 'not in [<integer>KB|MB|GB]' do
        let (:params) {{:port => port, :queueSize => 'bad_input'}}
        it {
          expect {
            should contain_file(concat_file)
          }.to raise_error(Puppet::Error, /\"bad_input\" does not match \"\^\\\\d\+\(KB\|MB\|GB\)\$\"/)
        }
      end
    end
    context 'with listenOnIPv6 ' do
      ['yes', 'no', 'only'].each do |size|
        context 'set to #{size}' do
          let (:params) {{:port => port, :listenOnIPv6 => size }}
          it {
            should contain_file(concat_file).with_content(/listenOnIPv6 = #{size}/m)
          }
        end
      end
      context 'not in [yes|no|only]' do
        let (:params) {{:port => port, :listenOnIPv6 => 'bad_input'}}
        it {
          expect {
            should contain_file(concat_file)
          }.to raise_error(Puppet::Error, /\"bad_input\" does not match \"\^yes\$\|\^no\$\|\^only\$\"/)
        }
      end
    end
    context 'with $acceptFrom set' do
      context 'to a single string' do
        let (:params) {{ :port => port, :acceptFrom => 'example.com' }}
        it {
          should contain_file(concat_file).with_content(/acceptFrom = example\.com/m)
        }
      end
      context 'to an array' do
        let (:params) {{ :port => port, :acceptFrom => ['example.com', '10.0.2.3'] }}
        it {
          should contain_file(concat_file).with_content(/acceptFrom = example\.com, 10\.0\.2\.3/m)
        }
      end
    end
    context "with compressed" do
      [true, false].each do |compressed|
        context "set to #{compressed}" do
          let(:params) {{ :port => port, :compressed => compressed }}
          it {
            should contain_file(concat_file).with_content(/compressed = #{compressed}/m)
          }
        end
      end
      [9999, "false", "true", "other thing"].each do |compressed|
        context "set to invalid value #{compressed}" do
          let(:params) {{ :port => port, :compressed => compressed }}
          it {
            expect {
              should contain_file(concat_file)
            }.to raise_error(Puppet::Error, /\"#{compressed}\" is not a boolean\./)
          }
        end
      end
    end
    context "with enableS2SHeartbeat" do
      [true, false].each do |enableS2SHeartbeat|
        context "set to #{enableS2SHeartbeat}" do
          let(:params) {{ :port => port, :enableS2SHeartbeat => enableS2SHeartbeat }}
          it {
            should contain_file(concat_file).with_content(/enableS2SHeartbeat = #{enableS2SHeartbeat}/m)
          }
        end
      end
      [9999, "false", "true", "other thing"].each do |enableS2SHeartbeat|
        context "set to invalid value #{enableS2SHeartbeat}" do
          let(:params) {{ :port => port, :enableS2SHeartbeat => enableS2SHeartbeat }}
          it {
            expect {
              should contain_file(concat_file)
            }.to raise_error(Puppet::Error, /\"#{enableS2SHeartbeat}\" is not a boolean\./)
          }
        end
      end
    end
    context "with negotiateNewProtocol" do
      [true, false].each do |negotiateNewProtocol|
        context "set to #{negotiateNewProtocol}" do
          let(:params) {{ :port => port, :negotiateNewProtocol => negotiateNewProtocol }}
          it {
            should contain_file(concat_file).with_content(/negotiateNewProtocol = #{negotiateNewProtocol}/m)
          }
        end
      end
      [9999, "false", "true", "other thing"].each do |negotiateNewProtocol|
        context "set to invalid value #{negotiateNewProtocol}" do
          let(:params) {{ :port => port, :negotiateNewProtocol => negotiateNewProtocol }}
          it {
            expect {
              should contain_file(concat_file)
            }.to raise_error(Puppet::Error, /\"#{negotiateNewProtocol}\" is not a boolean\./)
          }
        end
      end
    end
end
end