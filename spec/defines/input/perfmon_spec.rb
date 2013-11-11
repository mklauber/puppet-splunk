require 'spec_helper'
describe 'splunk::input::perfmon', :type => :define do

  concat_file = '/var/lib/puppet/concat/inputs.conf/fragments/10_perfmon-default'
  name = 'Example'
  object = 'Object'
  counter = 'Counter'

  let(:title) { 'default'}
  let(:facts) {{ :concat_basedir => '/var/lib/puppet/concat', :id => 'root' }}

  let(:params){{ 
    :name => name,
    :object => object,
    :counters => counter
  }}

  describe 'When creating a [perfmon] stanza' do
    it {
      should contain_file('inputs.conf').with_path('/opt/splunk/etc/system/local/inputs.conf')
      should contain_file(concat_file).with_content(/\[perfmon:\/\/#{name}\]/m)
      should contain_file(concat_file).with_content(/object = #{object}/m)
      should contain_file(concat_file).with_content(/counters = #{counter}/m)
    }
  end
  context "with showZeroValue" do
    [0, 1].each do |showZeroValue|
      context "set to #{showZeroValue}" do
        let(:params) {{ 
          :name => name,
          :object => object,
          :counters => counter,
          :showZeroValue => showZeroValue 
        }}
        it {
          should contain_file(concat_file).with_content(/showZeroValue = #{showZeroValue}/m)
        }
      end
    end
    [9999, "other thing"].each do |showZeroValue|
      context "set to invalid value #{showZeroValue}" do
        let(:params) {{ 
          :name => name,
          :object => object,
          :counters => counter,
          :showZeroValue => showZeroValue 
        }}
        it {
          expect {
            should contain_file(concat_file)
          }.to raise_error(Puppet::Error, /showZeroValue is not in \[0\|1\]\./)
        }
      end
    end
  end
  context "with disabled" do
    [0, 1].each do |disabled|
      context "set to #{disabled}" do
        let(:params) {{ 
          :name => name,
          :object => object,
          :counters => counter,
          :disabled => disabled 
        }}
        it {
          should contain_file(concat_file).with_content(/disabled = #{disabled}/m)
        }
      end
    end
    [9999, "other thing"].each do |disabled|
      context "set to invalid value #{disabled}" do
        let(:params) {{ 
          :name => name,
          :object => object,
          :counters => counter,
          :disabled => disabled 
        }}
        it {
          expect {
            should contain_file(concat_file)
          }.to raise_error(Puppet::Error, /\$disabled is not in \[0\|1\]\./)
        }
      end
    end
  end
  context 'with $counters set' do
    context 'to a single string' do
      let(:params){{ 
        :name => name,
        :object => object,
        :counters => 'single'
      }}
      it {
        should contain_file(concat_file).with_content(/counters = single/m)
      }
    end
    context 'to an array' do
      let(:params){{ 
              :name => name,
              :object => object,
              :counters => ['multiple', 'values']
            }}
      it {
        should contain_file(concat_file).with_content(/counters = multiple;values/m)
      }
    end
  end
  context 'with $instances set' do
    context 'to a single string' do
      let(:params){{ 
        :name => name,
        :object => object,
        :counters => counter,
        :instances => 'single'
      }}
      it {
        should contain_file(concat_file).with_content(/instances = single/m)
      }
    end
    context 'to an array' do
      let(:params){{ 
        :name => name,
        :object => object,
        :counters => counter,
        :instances => ['multiple', 'values']
      }}
      it {
        should contain_file(concat_file).with_content(/instances = multiple;values/m)
      }
    end
  end
context 'with $stats set' do
  context 'to a single string' do
    let(:params){{ 
      :name => name,
      :object => object,
      :counters => counter,
      :stats => 'single'
    }}
    it {
      should contain_file(concat_file).with_content(/stats = single/m)
    }
  end
  context 'to an array' do
    let(:params){{ 
      :name => name,
      :object => object,
      :counters => counter,
      :stats => ['multiple', 'values']
    }}
    it {
      should contain_file(concat_file).with_content(/stats = multiple;values/m)
    }
  end
end
end