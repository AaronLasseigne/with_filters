require 'spec_helper'

describe WithFilters::Filter do
  context 'defaults' do
    subject {described_class.new(:first_name, :foo)}

    its(:to_partial_path) {should == 'with_filters/filter'}
    its(:label)           {should == 'First Name'}
    its(:label_options)   {should == {}}
    its(:field_name)      {should == 'foo[first_name]'}
  end

  context 'options are passed' do
    context ':label' do
      it 'uses the provided label' do
        label = 'Given Name'
        described_class.new(:first_name, :foo, label: label).label.should == label
      end
    end

    context ':label_options' do
      it 'uses the provided label' do
        label_options = {
          class: 'label_class'
        }
        described_class.new(:first_name, :foo, label_options: label_options).label_options.should == label_options
      end
    end
  end
end
