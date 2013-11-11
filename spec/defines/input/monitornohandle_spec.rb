require 'spec_helper'
describe 'splunk::input::monitornohandle', :type => :define do

  concat_file = '/var/lib/puppet/concat/inputs.conf/fragments/10_monitornohandle-default'
  path = '/path/to/file'

  let(:title) { 'default'}
  let(:facts) {{ :concat_basedir => '/var/lib/puppet/concat', :id => 'root' }}

  let(:params){{ :path => path }}

  describe 'When creating a [MonitorNotHandle] stanza' do
    it {
      should contain_file('inputs.conf').with_path('/opt/splunk/etc/system/local/inputs.conf')
      should contain_file(concat_file).with_content(/\[MonitorNoHandle:\/\/#{path}\]/)
    }
  end
  context "with disabled" do
    [0, 1].each do |disabled|
      context "set to #{disabled}" do
        let(:params) {{ :path => path, :disabled => disabled }}
        it {
          should contain_file(concat_file).with_content(/disabled = #{disabled}/m)
        }
      end
    end
    [9999, "other thing"].each do |disabled|
      context "set to invalid value #{disabled}" do
        let(:params) {{ :path => path, :disabled => disabled }}
        it {
          expect {
            should contain_file(concat_file)
          }.to raise_error(Puppet::Error, /\$disabled is not in \[0\|1\]\./)
        }
      end
    end
  end
end