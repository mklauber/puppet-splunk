require 'spec_helper'
describe 'splunk::input::winregmon', :type => :define do

  concat_file = '/var/lib/puppet/concat/inputs.conf/fragments/10_winRegMon-default'
  name = 'HostName'

  let(:title) { 'default'}
  let(:facts) {{ :concat_basedir => '/var/lib/puppet/concat', :id => 'root' }}

  let(:params){{ :name => name }}

  describe 'When creating a [WinRegMon] stanza' do
    context 'with $name defined' do
      it {
        should contain_file('inputs.conf').with_path('/opt/splunk/etc/system/local/inputs.conf')
        should contain_file(concat_file).with_content(/\[WinRegMon:\/\/#{name}\]/)
      }
    end
    context 'without a name' do
      let (:params) {{}}
      it {
        expect {
          should contain_file(concat_file)
        }.to raise_error(Puppet::Error, /Must pass name to Splunk::Input::Winregmon\[default\]/)
      }
    end
    context 'with $proc set' do
      let (:params) {{:name => name, :proc => 'proc' }}
      it {
        should contain_file(concat_file).with_content(/proc = proc/m)
      }
    end
    context 'with $hive set' do
      let (:params) {{:name => name, :hive => 'hive' }}
      it {
        should contain_file(concat_file).with_content(/hive = hive/m)
      }
    end
    context 'with $type set' do
      let (:params) {{:name => name, :type => 'type' }}
      it {
        should contain_file(concat_file).with_content(/type = type/m)
      }
    end
    context "with baseline" do
      [0, 1].each do |baseline|
        context "set to #{baseline}" do
          let(:params) {{ :name => name, :baseline => baseline }}
          it {
            should contain_file(concat_file).with_content(/baseline = #{baseline}/m)
          }
        end
      end
      [9999, "other thing"].each do |baseline|
        context "set to invalid value #{baseline}" do
          let(:params) {{ :name => name, :baseline => baseline }}
          it {
            expect {
              should contain_file(concat_file)
            }.to raise_error(Puppet::Error, /\$baseline is not in \[0\|1\]\./)
          }
        end
      end
    end
    context 'with $baseline_interval set' do
      let (:params) {{:name => name, :baseline_interval => 'baseline_interval' }}
      it {
        should contain_file(concat_file).with_content(/baseline_interval = baseline_interval/m)
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
    context 'with $index set' do
      let (:params) {{:name => name, :index => 'index' }}
      it {
        should contain_file(concat_file).with_content(/index = index/m)
      }
    end
  end
end