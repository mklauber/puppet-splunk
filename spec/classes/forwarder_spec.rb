require 'spec_helper'

describe 'splunk::forwarder', :type => 'class' do
  
  let(:facts) {{ :concat_basedir => '/var/lib/puppet/concat', :id => 'root' }}
  
  describe 'When installing the spluk forwarder' do
    it {
      should include_class( 'splunk::forwarder' )

      should contain_package('splunkforwarder')
      .with( { 'name' => 'splunkforwarder' } ) 
      should contain_service('splunk')
      .with( { 'name' => 'splunk' } )

      }
  end
end