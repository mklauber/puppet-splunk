require 'spec_helper'
describe 'splunk::input::tcpssl', :type => :define do

  # Define top level variables to use throughout
  concat_file = '/var/lib/puppet/concat/inputs.conf/fragments/10_tcpssl-default'
  port = 9999
  
  # Set some context object the tests depend on
  let(:title) { 'default'}
  let(:facts) {{ :concat_basedir => '/var/lib/puppet/concat', :id => 'root' }}
  let(:params){{ :port => port }}

  # Start the tests
  describe 'When creating a tcp stanza' do
    it {
      should contain_file('inputs.conf').with_path('/opt/splunk/etc/system/local/inputs.conf')
      should contain_file(concat_file).with_content(/\[tcp-ssl:#{port}\]/)
    }
    context 'without a port' do
      let (:params) {{}}
      it {
        expect {
          should contain_file(concat_file)
        }.to raise_error(Puppet::Error, /Must pass port to Splunk::Input::Tcpssl\[default\]/)
      }
    end
    context 'with listenOnIPv6 ' do
      ['yes', 'no', 'only'].each do |listen|
        context "set to #{listen}" do
          let (:params) {{:port => port, :listenOnIPv6 => listen }}
          it {
            should contain_file(concat_file).with_content(/listenOnIPv6 = #{listen}/m)
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
  end
end