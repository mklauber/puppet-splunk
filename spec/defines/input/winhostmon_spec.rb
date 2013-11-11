require 'spec_helper'
describe 'splunk::input::winhostmon', :type => :define do

  concat_file = '/var/lib/puppet/concat/inputs.conf/fragments/10_winHostMon-default'
  name = 'HostName'

  let(:title) { 'default'}
  let(:facts) {{ :concat_basedir => '/var/lib/puppet/concat', :id => 'root' }}

  let(:params){{ :name => name }}

  describe 'When creating a [WinHostLog] stanza' do
    context 'with $name defined' do
      it {
        should contain_file('inputs.conf').with_path('/opt/splunk/etc/system/local/inputs.conf')
        should contain_file(concat_file).with_content(/\[WinHostMon:\/\/#{name}\]/)
      }
    end
    context 'without a name' do
      let (:params) {{}}
      it {
        expect {
          should contain_file(concat_file)
        }.to raise_error(Puppet::Error, /Must pass name to Splunk::Input::Winhostmon\[default\]/)
      }
    end
    context "with disabled" do
      [0, 1].each do |disabled|
        context "set to #{disabled}" do
          let(:params) {{ :name => name, :disabled => disabled }}
          it {
            should contain_file(concat_file).with_content(/disabled = #{disabled}/m)
          }
        end
      end
      [9999, "other thing"].each do |disabled|
        context "set to invalid value #{disabled}" do
          let(:params) {{ :name => name, :disabled => disabled }}
          it {
            expect {
              should contain_file(concat_file)
            }.to raise_error(Puppet::Error, /\$disabled is not in \[0\|1\]\./)
          }
        end
      end
    end
    context 'with $type set' do
      context 'to a single string' do
        let (:params) {{ :name => name, :type => 'example.com' }}
        it {
          should contain_file(concat_file).with_content(/type = example\.com/m)
        }
      end
      context 'to an array' do
        let (:params) {{ :name => name, :type => ['example.com', '10.0.2.3'] }}
        it {
          should contain_file(concat_file).with_content(/type = example\.com;10\.0\.2\.3/m)
        }
      end
    end
  end
end