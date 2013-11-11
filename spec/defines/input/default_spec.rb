require 'spec_helper'
describe 'splunk::input::default', :type => :define do

  concat_file = '/var/lib/puppet/concat/inputs.conf/fragments/01_input-default'
  let(:title) { 'default'}
  let(:facts) {{ :concat_basedir => '/var/lib/puppet/concat', :id => 'root' }}
    
  describe 'When creating a default stanza' do
    it {
      should contain_file('inputs.conf').with_path('/opt/splunk/etc/system/local/inputs.conf')
      should contain_file(concat_file).with_content(/\[default\]/)
    }
    context "with host defined" do
      let(:params) {{ :host => 'splunk.example.com' }}
      it {
      should contain_file(concat_file).with_content(/\[default\].*host = splunk\.example\.com/m)
      }
    end
    context "with index defined" do
      let(:params) {{ :index => 'example' }}
      it {
      should contain_file(concat_file).with_content(/\[default\].*index = example/m)
      }
    end

    context "with source defined" do
      let(:params) {{ :source => 'example' }}
      it {
      should contain_file(concat_file).with_content(/\[default\].*source = example/m)
      }
    end

    context "with sourcetype defined" do
      let(:params) {{ :sourcetype => 'example' }}
      it {
      should contain_file(concat_file).with_content(/\[default\].*sourcetype = example/m)
      }
    end

    context "with queue defined" do
      let(:params) {{ :queue => 'parsingQueue' }}
      it {
      should contain_file(concat_file).with_content(/\[default\].*queue = parsingQueue/m)
      }
    end
    context "with multiple parameters defined" do
      let(:params) {{
        :host       => 'splunk.example.com',
        :index      => 'example',
        :source     => 'example',
        :sourcetype => 'example',
        :queue      => 'parsingQueue'
      }}
      it {
      should contain_file(concat_file).with_content(/\[default\].*host = splunk\.example\.com/m)
      should contain_file(concat_file).with_content(/\[default\].*index = example/m)
      should contain_file(concat_file).with_content(/\[default\].*source = example/m)
      should contain_file(concat_file).with_content(/\[default\].*sourcetype = example/m)
      should contain_file(concat_file).with_content(/\[default\].*queue = parsingQueue/m)
      }
    end
  end
end