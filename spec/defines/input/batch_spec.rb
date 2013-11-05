require 'spec_helper'
describe 'splunk::input::batch', :type => :define do

  concat_file = '/var/lib/puppet/concat/inputs.conf/fragments/10_batch-default'
  path = '/var/log/path'

  let(:title) { 'default'}
  let(:facts) {{ :concat_basedir => '/var/lib/puppet/concat', :id => 'root' }}

  let(:params){{ :path => path }}

  describe 'When creating a [batch] stanza' do
    it {
      should contain_file('inputs.conf').with_path('/opt/splunk/etc/system/local/inputs.conf')
      should contain_file(concat_file).with_content(/[batch:\/\/#{Regexp.escape(path)}]/)
    }
  end
  context "with recursive" do
    [true, false].each do |recursive|
      context "set to #{recursive}" do
        let(:params) {{ :path => path, :recursive => recursive }}
        it {
          should contain_file(concat_file).with_content(/recursive = #{recursive}/m)
        }
      end
    end
    [9999, "false", "true", "other thing"].each do |recursive|
      context "set to invalid value #{recursive}" do
        let(:params) {{ :path => path, :recursive => recursive }}
        it {
          expect {
            should contain_file(concat_file)
          }.to raise_error(Puppet::Error, /\"#{recursive}\" is not a boolean\./)
        }
      end
    end
  end
  context "with followSymlink" do
    [true, false].each do |followSymlink|
      context "set to #{followSymlink}" do
        let(:params) {{ :path => path, :followSymlink => followSymlink }}
        it {
          should contain_file(concat_file).with_content(/followSymlink = #{followSymlink}/m)
        }
      end
    end
    [9999, "false", "true", "other thing"].each do |followSymlink|
      context "set to invalid value #{followSymlink}" do
        let(:params) {{ :path => path, :followSymlink => followSymlink }}
        it {
          expect {
            should contain_file(concat_file)
          }.to raise_error(Puppet::Error, /\"#{followSymlink}\" is not a boolean\./)
        }
      end
    end
  end
end