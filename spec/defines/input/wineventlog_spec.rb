require 'spec_helper'
describe 'splunk::input::wineventlog', :type => :define do

  concat_file = '/var/lib/puppet/concat/inputs.conf/fragments/10_winEventLog-default'
  name = 'EventName'

  let(:title) { 'default'}
  let(:facts) {{ :concat_basedir => '/var/lib/puppet/concat', :id => 'root' }}

  let(:params){{ :name => name }}

  describe 'When creating a [WinEventLog] stanza' do
    context 'with $name defined' do
      it {
        should contain_file('inputs.conf').with_path('/opt/splunk/etc/system/local/inputs.conf')
        should contain_file(concat_file).with_content(/\[WinEventLog:\/\/#{name}\]/)
      }
    end
    context 'without a name' do
      let (:params) {{}}
      it {
        expect {
          should contain_file(concat_file)
        }.to raise_error(Puppet::Error, /Must pass name to Splunk::Input::Wineventlog\[default\]/)
      }
    end
    context "with current_only" do
      [0, 1].each do |current_only|
        context "set to #{current_only}" do
          let(:params) {{ :name => name, :current_only => current_only }}
          it {
            should contain_file(concat_file).with_content(/current_only = #{current_only}/m)
          }
        end
      end
      [9999, "other thing"].each do |current_only|
        context "set to invalid value #{current_only}" do
          let(:params) {{ :name => name, :current_only => current_only }}
          it {
            expect {
              should contain_file(concat_file)
            }.to raise_error(Puppet::Error, /\$current_only is not in \[0\|1\]\./)
          }
        end
      end
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
    context "with evt_resolve_ad_obj" do
      [0, 1].each do |evt_resolve_ad_obj|
        context "set to #{evt_resolve_ad_obj}" do
          let(:params) {{ :name => name, :evt_resolve_ad_obj => evt_resolve_ad_obj }}
          it {
            should contain_file(concat_file).with_content(/evt_resolve_ad_obj = #{evt_resolve_ad_obj}/m)
          }
        end
      end
      [9999, "other thing"].each do |evt_resolve_ad_obj|
        context "set to invalid value #{evt_resolve_ad_obj}" do
          let(:params) {{ :name => name, :evt_resolve_ad_obj => evt_resolve_ad_obj }}
          it {
            expect {
              should contain_file(concat_file)
            }.to raise_error(Puppet::Error, /\$evt_resolve_ad_obj is not in \[0\|1\]\./)
          }
        end
      end
    end
    context "with suppress_text" do
      [0, 1].each do |suppress_text|
        context "set to #{suppress_text}" do
          let(:params) {{ :name => name, :suppress_text => suppress_text }}
          it {
            should contain_file(concat_file).with_content(/suppress_text = #{suppress_text}/m)
          }
        end
      end
      [9999, "other thing"].each do |suppress_text|
        context "set to invalid value #{suppress_text}" do
          let(:params) {{ :name => name, :suppress_text => suppress_text }}
          it {
            expect {
              should contain_file(concat_file)
            }.to raise_error(Puppet::Error, /\$suppress_text is not in \[0\|1\]\./)
          }
        end
      end
    end
  end
end