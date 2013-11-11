require 'spec_helper'
describe 'splunk::input::fschange', :type => :define do

  # Define top level variables to use throughout
  concat_file = '/var/lib/puppet/concat/inputs.conf/fragments/10_fschange-default'
  path = '/path/to/file'
  
  # Set some context object the tests depend on
  let(:title) { 'default'}
  let(:facts) {{ :concat_basedir => '/var/lib/puppet/concat', :id => 'root' }}
  let(:params){{ :path => path }}

  # Start the tests
  describe 'When creating a [fschange] stanza' do
    it {
      should contain_file('inputs.conf').with_path('/opt/splunk/etc/system/local/inputs.conf')
      should contain_file(concat_file).with_content(/\[fschange:#{Regexp.escape(path)}\]/)
    }
    context 'without a path' do
      let (:params) {{}}
      it {
        expect {
          should contain_file(concat_file)
        }.to raise_error(Puppet::Error, /Must pass path to Splunk::Input::Fschange\[default\]/)
      }
    end
    context "with recurse" do
      [true, false].each do |recurse|
        context "set to #{recurse}" do
          let(:params) {{ :path => path, :recurse => recurse }}
          it {
            should contain_file(concat_file).with_content(/recurse = #{recurse}/m)
          }
        end
      end
      [9999, "false", "true", "other thing"].each do |recurse|
        context "set to invalid value #{recurse}" do
          let(:params) {{ :path => path, :recurse => recurse }}
          it {
            expect {
              should contain_file(concat_file)
            }.to raise_error(Puppet::Error, /\"#{recurse}\" is not a boolean\./)
          }
        end
      end
    end
    context "with signedaudit" do
      [true, false].each do |signedaudit|
        context "set to #{signedaudit}" do
          let(:params) {{ :path => path, :signedaudit => signedaudit }}
          it {
            should contain_file(concat_file).with_content(/signedaudit = #{signedaudit}/m)
          }
        end
      end
      [9999, "false", "true", "other thing"].each do |signedaudit|
        context "set to invalid value #{signedaudit}" do
          let(:params) {{ :path => path, :signedaudit => signedaudit }}
          it {
            expect {
              should contain_file(concat_file)
            }.to raise_error(Puppet::Error, /\"#{signedaudit}\" is not a boolean\./)
          }
        end
      end
    end
    context "with followLinks" do
      [true, false].each do |followLinks|
        context "set to #{followLinks}" do
          let(:params) {{ :path => path, :followLinks => followLinks }}
          it {
            should contain_file(concat_file).with_content(/followLinks = #{followLinks}/m)
          }
        end
      end
      [9999, "false", "true", "other thing"].each do |followLinks|
        context "set to invalid value #{followLinks}" do
          let(:params) {{ :path => path, :followLinks => followLinks }}
          it {
            expect {
              should contain_file(concat_file)
            }.to raise_error(Puppet::Error, /\"#{followLinks}\" is not a boolean\./)
          }
        end
      end
    end
    context "with fullEvent" do
      [true, false].each do |fullEvent|
        context "set to #{fullEvent}" do
          let(:params) {{ :path => path, :fullEvent => fullEvent }}
          it {
            should contain_file(concat_file).with_content(/fullEvent = #{fullEvent}/m)
          }
        end
      end
      [9999, "false", "true", "other thing"].each do |fullEvent|
        context "set to invalid value #{fullEvent}" do
          let(:params) {{ :path => path, :fullEvent => fullEvent }}
          it {
            expect {
              should contain_file(concat_file)
            }.to raise_error(Puppet::Error, /\"#{fullEvent}\" is not a boolean\./)
          }
        end
      end
    end
    context 'with filters set' do
      context 'to a single string' do
        let (:params) {{ :path => path, :filters => 'example' }}
        it {
          should contain_file(concat_file).with_content(/filters = example/m)
        }
      end
      context 'to an array' do
        let (:params) {{ :path => path, :filters => ['example_one', 'example_two'] }}
        it {
          should contain_file(concat_file).with_content(/filters = example_one, example_two/m)
        }
      end
    end
  end
end