require 'spec_helper'

describe WithFilters::Action do
  describe '#initialize(type, options = {})' do
    context 'defaults' do
      subject {described_class.new(:submit)}

      its(:type)  {should be :submit}
      its(:attrs) {should == {type: :submit}}
    end

    context 'options' do
      context ':label' do
        it 'labels the button' do
          described_class.new(:submit, label: 'Submit').attrs[:value].should == 'Submit'
        end
      end
    end
  end
end
