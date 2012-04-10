require 'spec_helper'

describe WithFilters::Filter::Base do
  describe '#initialize(name, namespace, value, options = {})' do
    context 'defaults' do
      subject {described_class.new(:first_name, :foo, 'Aaron')}

      its(:to_partial_path) {should == File.join('with_filters', 'filter', 'base')}
      its(:label)           {should == 'First Name'}
      its(:label_attrs)     {should == {}}
      its(:field_name)      {should == 'foo[first_name]'}
      its(:value)           {should == 'Aaron'}
      it 'has no collection' do
        subject.collection.should be_nil
      end
    end

    context 'options' do
      context ':field_name' do
        it 'manually sets the field name' do
          field_name = 'fname'
          described_class.new(:first_name, :foo, 'Aaron', field_name: field_name).field_name.should == field_name
        end
      end

      context ':label' do
        it 'uses the provided label' do
          label = 'Given Name'
          described_class.new(:first_name, :foo, 'Aaron', label: label).label.should == label
        end
      end

      context ':label_attrs' do
        it 'uses the provided label attrs' do
          label_attrs = {
            class: 'label_class'
          }
          described_class.new(:first_name, :foo, 'Aaron', label_attrs: label_attrs).label_attrs.should == label_attrs
        end
      end

      context ':collection' do
        it 'creates collection from the provided list' do
          collection = described_class.new(:gender, :foo, 'Male', collection: ['Male', 'Female']).collection
          collection.should be_a_kind_of(WithFilters::Filter::Collection)
          collection.first.label.should == 'Male'
          collection.last.label.should  == 'Female'
        end
      end

      context ':theme' do
        it 'uses the provided theme to create a partial path' do
          Dir.stub(:glob).and_return([File.join(Rails.root, 'app', 'views', 'with_filters', 'foo', 'filter', '_base.html.erb')])

          filter = described_class.new(:first_name, :foo, 'Aaron', theme: 'foo')

          filter.to_partial_path.should == File.join('with_filters', 'foo', 'filter', 'base')
        end

        it 'falls back to the original partials if the theme version can not be found' do
          Dir.stub(:glob).and_return([])

          filter = described_class.new(:first_name, :foo, 'Aaron', theme: 'foo')

          filter.to_partial_path.should == File.join('with_filters', 'filter', 'base')
        end
      end

      context 'everything else' do
        it 'gets put in attrs' do
          described_class.new(:first_name, :foo, 'Aaron', {label: 'Given Name', class: 'input_class'}).attrs.should == {class: 'input_class'}
        end
      end
    end
  end
end
