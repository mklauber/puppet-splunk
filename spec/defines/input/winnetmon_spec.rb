require 'spec_helper'
describe 'splunk::input::winnetmon', :type => :define do

  concat_file = '/var/lib/puppet/concat/inputs.conf/fragments/10_winNetMon-default'
  name = 'HostName'

  let(:title) { 'default'}
  let(:facts) {{ :concat_basedir => '/var/lib/puppet/concat', :id => 'root' }}

  let(:params){{ :name => name }}

  describe 'When creating a [WinNetLog] stanza' do
    context 'with $name defined' do
      it {
        should contain_file('inputs.conf').with_path('/opt/splunk/etc/system/local/inputs.conf')
        should contain_file(concat_file).with_content(/\[WinNetMon:\/\/#{name}\]/)
      }
    end
    context 'without a name' do
      let (:params) {{}}
      it {
        expect {
          should contain_file(concat_file)
        }.to raise_error(Puppet::Error, /Must pass name to Splunk::Input::Winnetmon\[default\]/)
      }
    end
    context 'with $remoteAddress defined' do
      regex = '/regex/'
      let (:params) {{ :name => name, :remoteAddress => regex }}
      it {
        should contain_file(concat_file).with_content(/remoteAddress = #{Regexp.escape(regex)}/m)
      }
    end
    context 'with $process defined' do
      regex = '/regex/'
      let (:params) {{ :name => name, :process => regex }}
      it {
        should contain_file(concat_file).with_content(/process = #{Regexp.escape(regex)}/m)
      }
    end
    context 'with $user defined' do
      regex = '/regex/'
      let (:params) {{ :name => name, :user => regex }}
      it {
        should contain_file(concat_file).with_content(/user = #{Regexp.escape(regex)}/m)
      }
    end
    context 'with $addressFamily' do
      ['ipv4', 'ipv6'].each do |addressFamily|
        context 'set to #{addressFamily}' do
          let (:params) {{ :name => name, :addressFamily => addressFamily }}
          it {
            should contain_file(concat_file).with_content(/addressFamily = #{addressFamily}/m)
          }
        end
      end
      context 'set to a list' do
        let (:params) {{ :name => name, :addressFamily => ['ipv4', 'ipv6'] }}
        it {
          should contain_file(concat_file).with_content(/addressFamily = ipv4;ipv6/m)
        }
      end
    end
    context 'with $packetType' do
      ['connect', 'accept', 'transname'].each do |packetType|
        context 'set to #{packetType}' do
          let (:params) {{ :name => name, :packetType => packetType }}
          it {
            should contain_file(concat_file).with_content(/packetType = #{packetType}/m)
          }
        end
      end
      context 'set to a list' do
        let (:params) {{ :name => name, :packetType => ['connect', 'accept', 'transname'] }}
        it {
          should contain_file(concat_file).with_content(/packetType = connect;accept;transname/m)
        }
      end
    end
    context 'with $direction' do
      ['inbound', 'outbound'].each do |direction|
        context 'set to #{direction}' do
          let (:params) {{ :name => name, :direction => direction }}
          it {
            should contain_file(concat_file).with_content(/direction = #{direction}/m)
          }
        end
      end
      context 'set to a list' do
        let (:params) {{ :name => name, :direction => ['inbound', 'outbound'] }}
        it {
          should contain_file(concat_file).with_content(/direction = inbound;outbound/m)
        }
      end
    end
    context 'with $protocol' do
      ['tcp', 'udp'].each do |protocol|
        context 'set to #{protocol}' do
          let (:params) {{ :name => name, :protocol => protocol }}
          it {
            should contain_file(concat_file).with_content(/protocol = #{protocol}/m)
          }
        end
      end
      context 'set to a list' do
        let (:params) {{ :name => name, :protocol => ['tcp', 'udp'] }}
        it {
          should contain_file(concat_file).with_content(/protocol = tcp;udp/m)
        }
      end
    end
    context 'with $mode' do
      ['single', 'multikv'].each do |mode|
        context 'set to #{mode}' do
          let (:params) {{ :name => name, :mode => mode }}
          it {
            should contain_file(concat_file).with_content(/mode = #{mode}/m)
          }
        end
      end
      context 'not in [single|multikv]' do
        let (:params) {{ :name => name, :mode => 'bad_input' }}
        it {
          expect {
            should contain_file(concat_file)
          }.to raise_error(Puppet::Error, /\"bad_input\" does not match \"\^single\$\|\^multikv\$\"/)
        }
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
end