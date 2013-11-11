require 'spec_helper'
describe 'splunk::output::indexandforward', :type => :define do

  concat_file = '/var/lib/puppet/concat/outputs.conf/fragments/10_indexandforward'
  let(:title) { 'default'}
  let(:facts) {{ :concat_basedir => '/var/lib/puppet/concat', :id => 'root' }}
  
  describe 'When creating a indexAndForward stanza' do
    
    it {
      should contain_file('outputs.conf').with_path('/opt/splunk/etc/system/local/outputs.conf')
      should contain_file(concat_file).with_content(/\[indexAndForward\]/)
    }
  end
  context "with index" do
    [true, false].each do |index|
      context "set to #{index}" do
        let(:params) {{ :index => index }}
        it {
          should contain_file(concat_file).with_content(/\[indexAndForward\].*index = #{index}/m)
        }
      end
    end
    [9999, "false", "true", "other thing"].each do |index|
      context "set to invalid value #{index}" do
        let (:params) {{:index => index}}
        it {
          expect {
            should contain_file(concat_file)
          }.to raise_error(Puppet::Error, /\"#{index}\" is not a boolean\./)
        }
      end
    end
  end
  context "with selectiveIndexing" do
    [true, false].each do |index|
      context "set to #{index}" do
        let(:params) {{ :selectiveIndexing => index }}
        it {
          should contain_file(concat_file).with_content(/\[indexAndForward\].*selectiveIndexing = #{index}/m)
        }
      end
    end
    [9999, "false", "true", "other thing"].each do |index|
      context "set to invalid value #{index}" do
        let (:params) {{:selectiveIndexing => index}}
        it {
          expect {
            should contain_file(concat_file)
          }.to raise_error(Puppet::Error, /\"#{index}\" is not a boolean\./)
        }
      end
    end
  end
end