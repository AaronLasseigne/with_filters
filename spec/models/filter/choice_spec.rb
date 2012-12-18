require 'spec_helper'

describe WithFilters::Filter::Choice do
  describe '#initialize(field_name, label, value, options = {})' do
    context 'default' do
      subject { described_class.new('field', 'One', 1) }

      its(:field_name) { should == 'field[]' }
      its(:label)      { should == 'One' }
      its(:value)      { should be 1 }
      its(:selected?)  { should be_false }
      its(:attrs)      { should == {id: 'field_1'} }
    end

    context 'options' do
      context ':selected' do
        subject { described_class.new('field', 'One', 1, selected: true) }
        
        its(:selected?) { should be_true }
        its(:attrs)     { should == {id: 'field_1'} }
      end
    end
  end
end
