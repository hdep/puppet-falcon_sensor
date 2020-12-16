require 'spec_helper'
describe 'falcon_sensor' do
  context 'with defaults for all parameters' do
    it {
      is_expected.to contain_class('falcon_sensor')
      is_expected.to contain_package('falcon-sensor')
    }
  end

  context 'with ensure absent' do
    let(:params) {{
      :ensure => 'absent'
    }}
    
    it {
      is_expected.to contain_class('falcon_sensor')
      is_expected.to contain_package('falcon-sensor').with_ensure('absent')
    }
  end

  context 'with autoupgrade enabled' do
    let(:params) {{
      :autoupgrade => true
    }}
    
    it {
      is_expected.to contain_class('falcon_sensor')
      is_expected.to contain_package('falcon-sensor').with_ensure('latest')
    }
  end
end
