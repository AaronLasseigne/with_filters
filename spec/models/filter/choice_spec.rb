require 'spec_helper'

describe WithFilters::Filter::Choice do
  describe '#initialize(label, value, options = {})' do
    context 'default' do
      subject {described_class.new('One', 1)}

      its(:label)     {should == 'One'}
      its(:value)     {should == 1}
      its(:selected?) {should be_false}
      its(:attrs)     {should be_empty}
    end

    context 'options' do
      context ':selected' do
        subject {described_class.new('One', 1, selected: true)}
        
        its(:selected?) {should be_true}
        its(:attrs)     {should be_empty}
      end
    end
  end
end
