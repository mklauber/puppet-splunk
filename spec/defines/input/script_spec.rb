require 'spec_helper'
describe 'splunk::input::script', :type => :define do

  # Define top level variables to use throughout
  concat_file = '/var/lib/puppet/concat/inputs.conf/fragments/10_script-default'
  cmd = 'cmd'
  
  # Set some context object the tests depend on
  let(:title) { 'default'}
  let(:facts) {{ :concat_basedir => '/var/lib/puppet/concat', :id => 'root' }}
  let(:params){{ :cmd => cmd }}

  # Start the tests
  describe 'When creating a [script] stanza' do
    it {
      should contain_file('inputs.conf').with_path('/opt/splunk/etc/system/local/inputs.conf')
      should contain_file(concat_file).with_content(/[script:\/\/#{cmd}]/)
    }
    context 'without a cmd' do
      let (:params) {{}}
      it {
        expect {
          should contain_file(concat_file)
        }.to raise_error(Puppet::Error, /Must pass cmd to Splunk::Input::Script\[default\]/)
      }
    end
    context "with start_by_Shell" do
      [true, false].each do |start_by_shell|
        context "set to #{start_by_shell}" do
          let(:params) {{ :cmd => cmd, :start_by_shell => start_by_shell }}
          it {
            should contain_file(concat_file).with_content(/start_by_shell = #{start_by_shell}/m)
          }
        end
      end
      [9999, "false", "true", "other thing"].each do |start_by_shell|
        context "set to invalid value #{start_by_shell}" do
          let(:params) {{ :cmd => cmd, :start_by_shell => start_by_shell }}
          it {
            expect {
              should contain_file(concat_file)
            }.to raise_error(Puppet::Error, /\"#{start_by_shell}\" is not a boolean\./)
          }
        end
      end
    end
    context 'with queueSize' do
      context 'in KB, MB, or GB' do
        ['10KB', '20KB', '11MB', '21MB', '12GB', '22GB'].each do |size|
          let (:params) {{:cmd => cmd, :queueSize => size }}
          it {
            should contain_file(concat_file).with_content(/[queueSize = #{size}]/m)
          }          
        end
      end
      context 'not in [<integer>KB|MB|GB]' do
        let (:params) {{:cmd => cmd, :queueSize => 'bad_input'}}
        it {
          expect {
            should contain_file(concat_file)
          }.to raise_error(Puppet::Error, /\"bad_input\" does not match \"\^\\\\d\+\(KB\|MB\|GB\)\$\"/)
        }
      end
    end
    context 'with persistentQueueSize' do
      context 'in KB, MB, or GB' do
        ['10KB', '20KB', '11MB', '21MB', '12GB', '22GB', '13TB', '23TB'].each do |size|
          let (:params) {{:cmd => cmd, :persistentQueueSize => size }}
          it {
            should contain_file(concat_file).with_content(/[persistentQueueSize = #{size}]/m)
          }          
        end
      end
      context 'not in [<integer>KB|MB|GB]' do
        let (:params) {{:cmd => cmd, :persistentQueueSize => 'bad_input'}}
        it {
          expect {
            should contain_file(concat_file)
          }.to raise_error(Puppet::Error, /\"bad_input\" does not match \"\^\\\\d\+\(KB\|MB\|GB\|TB\)\$\"/)
        }
      end
    end
  end
end