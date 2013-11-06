require 'spec_helper'
describe 'splunk::input::winprintmon', :type => :define do

  concat_file = '/var/lib/puppet/concat/inputs.conf/fragments/10_winprintmon-default'
  name = 'PrinterName'

  let(:title) { 'default'}
  let(:facts) {{ :concat_basedir => '/var/lib/puppet/concat', :id => 'root' }}

  let(:params){{ :name => name }}

  describe 'When creating a [WinPrintMon] stanza' do
    it {
      should contain_file('inputs.conf').with_path('/opt/splunk/etc/system/local/inputs.conf')
      should contain_file(concat_file).with_content(/[WinPrintMon:\/\/#{name}]/)
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
          }.to raise_error(Puppet::Error, /baseline is not in \[0\|1\]\./)
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
end