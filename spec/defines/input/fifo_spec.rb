require 'spec_helper'
describe 'splunk::input::fifo', :type => :define do

  # Define top level variables to use throughout
  concat_file = '/var/lib/puppet/concat/inputs.conf/fragments/10_fifo-default'
  path = '/an/example/path'
  
  # Set some context object the tests depend on
  let(:title) { 'default'}
  let(:facts) {{ :concat_basedir => '/var/lib/puppet/concat', :id => 'root' }}
  let(:params){{ :path => path }}

  # Start the tests
  describe 'When creating a fifo stanza' do
    it {
      should contain_file('inputs.conf').with_path('/opt/splunk/etc/system/local/inputs.conf')
      should contain_file(concat_file).with_content(/\[fifo:\/\/#{Regexp.escape(path)}\]/)
    }
    context 'without a path' do
      let (:params) {{}}
      it {
        expect {
          should contain_file(concat_file)
        }.to raise_error(Puppet::Error, /Must pass path to Splunk::Input::Fifo\[default\]/)
      }
    end
    context 'with queueSize' do
      ['10KB', '20KB', '11MB', '21MB', '12GB', '22GB'].each do |size|
        context 'set to #{size}' do
          let (:params) {{:path => path, :queueSize => size }}
          it {
            should contain_file(concat_file).with_content(/queueSize = #{size}/m)
          }          
        end
      end
      context 'not in [<integer>KB|MB|GB]' do
        let (:params) {{:path => path, :queueSize => 'bad_input'}}
        it {
          expect {
            should contain_file(concat_file)
          }.to raise_error(Puppet::Error, /\"bad_input\" does not match \"\^\\\\d\+\(KB\|MB\|GB\)\$\"/)
        }
      end
    end
    context 'with persistentQueueSize' do
      ['10KB', '20KB', '11MB', '21MB', '12GB', '22GB', '13TB', '23TB'].each do |size|
        context 'set to #{size}' do
          let (:params) {{:path => path, :persistentQueueSize => size }}
          it {
            should contain_file(concat_file).with_content(/persistentQueueSize = #{size}/m)
          }          
        end
      end
      context 'not in [<integer>KB|MB|GB]' do
        let (:params) {{:path => path, :persistentQueueSize => 'bad_input'}}
        it {
          expect {
            should contain_file(concat_file)
          }.to raise_error(Puppet::Error, /\"bad_input\" does not match \"\^\\\\d\+\(KB\|MB\|GB\|TB\)\$\"/)
        }
      end
    end
    context 'with all the parameters defined' do
      let(:params){{
        :path                => path,
        :queueSize           => '10KB',
        :persistentQueueSize => '10TB'
      }}
      it {
        should contain_file(concat_file).with_content(/\[fifo:\/\/#{path}\]/m)
        should contain_file(concat_file).with_content(/queueSize = 10KB/m)
        should contain_file(concat_file).with_content(/persistentQueueSize = 10TB/m)
      }
    end

  end
end