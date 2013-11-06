require 'spec_helper'
describe 'splunk::input::filter', :type => :define do

  # Define top level variables to use throughout
  concat_file = '/var/lib/puppet/concat/inputs.conf/fragments/10_filter-default'
  type = 'whitelist'
  name = 'Name'
  
  # Set some context object the tests depend on
  let(:title) { 'default'}
  let(:facts) {{ :concat_basedir => '/var/lib/puppet/concat', :id => 'root' }}
  let(:params){{ 
    :filtertype => type, 
    :filtername => name,
    :regex => '/regex string/'
  }}

  # Start the tests
  describe 'When creating a monitor stanza' do
    it {
      should contain_file('inputs.conf').with_path('/opt/splunk/etc/system/local/inputs.conf')
      should contain_file(concat_file).with_content(/[filter:#{type}:#{name}]/)
      should contain_file(concat_file).with_content(/regex1=\/regex string\//)
    }
    context 'without a filtertype' do
      let (:params) {{
        :filtername => name,
        :regex => '/regex string/'
      }}
      it {
        expect {
          should contain_file('#{concat_file}')
        }.to raise_error(Puppet::Error, /Must pass filtertype to Splunk::Input::Filter\[default\]/)
      }
    end
    context 'without a filtername' do
      let (:params) {{
        :filtertype => type, 
        :regex => '/regex string/'
      }}
      it {
        expect {
          should contain_file('#{concat_file}')
        }.to raise_error(Puppet::Error, /Must pass filtername to Splunk::Input::Filter\[default\]/)
      }
    end
    context 'without a regex' do
      let (:params) {{
        :filtertype => type, 
        :filtername => name,
      }}
      it {
        expect {
          should contain_file('#{concat_file}')
        }.to raise_error(Puppet::Error, /Must pass regex to Splunk::Input::Filter\[default\]/)
      }
    end
    context 'with an array of regexes' do
      let (:params) {{ 
        :filtertype => type, 
        :filtername => name,
        :regex => ['/one/regex/', '/another/regex/'] }}
      it {
        should contain_file("#{concat_file}").with_content(/regex1=\/one\/regex\//)
        should contain_file("#{concat_file}").with_content(/regex2=\/another\/regex\//)
      }
    end
    context 'with filtertype' do
      context 'in [whitelist|blacklist]' do
        ['whitelist', 'blacklist'].each do |filtertype|
          let(:params){{ 
            :filtertype => filtertype, 
            :filtername => name,
            :regex => '/regex string/'
          }}
          it {
            should contain_file(concat_file).with_content(/[filter:#{filtertype}:#{name}]/m)
          }          
        end
      end
      context 'not in [whitelist|blacklist]' do
        [9999, 'thingie'].each do |filtertype|
          let(:params){{
            :filtertype => filtertype, 
            :filtername => name,
            :regex => '/regex string/'
          }}
          it {
            expect {
              should contain_file(concat_file)
            }.to raise_error(Puppet::Error, /filtertype must be in \[whitelist\|blacklist\]/)
          }
        end
      end
    end
  end
end