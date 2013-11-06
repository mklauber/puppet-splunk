require 'spec_helper'
describe 'splunk::input::admon', :type => :define do

  concat_file = '/var/lib/puppet/concat/inputs.conf/fragments/10_admon-default'
  name = 'Example'

  let(:title) { 'default'}
  let(:facts) {{ :concat_basedir => '/var/lib/puppet/concat', :id => 'root' }}

  let(:params){{ :name => name }}

  describe 'When creating a [WinPrintMon] stanza' do
    it {
      should contain_file('inputs.conf').with_path('/opt/splunk/etc/system/local/inputs.conf')
      should contain_file(concat_file).with_content(/[AdMon:\/\/#{name}]/)
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
  context "with printSchema" do
    [0, 1].each do |printSchema|
      context "set to #{printSchema}" do
        let(:params) {{ :name => name, :printSchema => printSchema }}
        it {
          should contain_file(concat_file).with_content(/printSchema = #{printSchema}/m)
        }
      end
    end
    [9999, "other thing"].each do |printSchema|
      context "set to invalid value #{printSchema}" do
        let(:params) {{ :name => name, :printSchema => printSchema }}
        it {
          expect {
            should contain_file(concat_file)
          }.to raise_error(Puppet::Error, /\$printSchema is not in \[0\|1\]\./)
        }
      end
    end
  end
  context "with monitorSubtree" do
    [0, 1].each do |monitorSubtree|
      context "set to #{monitorSubtree}" do
        let(:params) {{ :name => name, :monitorSubtree => monitorSubtree }}
        it {
          should contain_file(concat_file).with_content(/monitorSubtree = #{monitorSubtree}/m)
        }
      end
    end
    [9999, "other thing"].each do |monitorSubtree|
      context "set to invalid value #{monitorSubtree}" do
        let(:params) {{ :name => name, :monitorSubtree => monitorSubtree }}
        it {
          expect {
            should contain_file(concat_file)
          }.to raise_error(Puppet::Error, /\$monitorSubtree is not in \[0\|1\]\./)
        }
      end
    end
  end
end