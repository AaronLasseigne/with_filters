require 'spec_helper'

describe WithFilters::Filter::Base do
  describe '#initialize(name, namespace, value, options = {})' do
    context 'defaults' do
      subject {described_class.new(:first_name, :foo, 'Aaron')}

      its(:to_partial_path) {should == 'with_filters/filter/base'}
      its(:label)           {should == 'First Name'}
      its(:label_attrs)     {should == {}}
      its(:field_name)      {should == 'foo[first_name]'}
      its(:value)           {should == 'Aaron'}
      it 'has no choices' do
        subject.choices.should be_nil
      end
    end

    context 'options' do
      context ':label' do
        it 'uses the provided label' do
          label = 'Given Name'
          described_class.new(:first_name, :foo, 'Aaron', label: label).label.should == label
        end
      end

      context ':label_attrs' do
        it 'uses the provided label' do
          label_attrs = {
            class: 'label_class'
          }
          described_class.new(:first_name, :foo, 'Aaron', label_attrs: label_attrs).label_attrs.should == label_attrs
        end
      end

      context ':choices' do
        choices = described_class.new(:gender, :foo, 'Male', choices: ['Male', 'Female']).choices
        choices.first.label.should == 'Male'
        choices.last.label.should  == 'Female'
      end

      context 'everything else' do
        it 'gets put in attrs' do
          described_class.new(:first_name, :foo, 'Aaron', {label: 'Given Name', class: 'input_class'}).attrs.should == {class: 'input_class'}
        end
      end
    end
  end
end
