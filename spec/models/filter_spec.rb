require 'spec_helper'

describe WithFilters::Filter do
  context 'defaults' do
    subject {described_class.new(:first_name, :foo)}

    its(:to_partial_path) {should == 'with_filters/filter'}
    its(:label)           {should == 'First Name'}
    its(:label_attrs)     {should == {}}
    its(:field_name)      {should == 'foo[first_name]'}
  end

  context 'options are passed' do
    context ':label' do
      it 'uses the provided label' do
        label = 'Given Name'
        described_class.new(:first_name, :foo, label: label).label.should == label
      end
    end

    context ':label_attrs' do
      it 'uses the provided label' do
        label_attrs = {
          class: 'label_class'
        }
        described_class.new(:first_name, :foo, label_attrs: label_attrs).label_attrs.should == label_attrs
      end
    end

    context 'everything else' do
      it 'gets put in attrs' do
        described_class.new(:first_name, :foo, {label: 'Given Name', class: 'input_class'}).attrs.should == {class: 'input_class'}
      end
    end
  end
end
