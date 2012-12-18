require 'spec_helper'

describe WithFilters::Filter::Base do
  describe '#initialize(name, namespace, value, options = {})' do
    context 'defaults' do
      subject(:filter) { described_class.new(:first_name, :foo, 'Aaron') }

      its(:to_partial_path) { should == File.join('with_filters', 'filter', 'base') }
      its(:label)           { should == 'First Name' }
      its(:label_attrs)     { should == {} }
      its(:field_name)      { should == 'foo[first_name]' }
      its(:value)           { should == 'Aaron' }
      it 'has no collection' do
        expect(filter.collection).to be_nil
      end
    end

    context 'options' do
      context ':field_name' do
        it 'manually sets the field name' do
          field_name = 'fname'
          filter     = described_class.new(:first_name, :foo, 'Aaron',
            field_name: field_name
          )

          expect(filter.field_name).to eq field_name
        end
      end

      context ':label' do
        it 'uses the provided label' do
          label  = 'Given Name'
          filter = described_class.new(:first_name, :foo, 'Aaron',
            label: label
          )
          
          expect(filter.label).to eq label
        end
      end

      context ':label_attrs' do
        it 'uses the provided label attrs' do
          label_attrs = {
            class: 'label_class'
          }
          filter = described_class.new(:first_name, :foo, 'Aaron',
            label_attrs: label_attrs
          )

          expect(filter.label_attrs).to eq label_attrs
        end
      end

      context ':collection' do
        it 'creates collection from the provided list' do
          collection = described_class.new(:gender, :foo, 'Male',
            collection: %w(Male Female)
          ).collection

          expect(collection).to be_a_kind_of(WithFilters::Filter::Collection)
          expect(collection.first.label).to eq 'Male'
          expect(collection.last.label).to eq 'Female'
        end
      end

      context ':theme' do
        it 'uses the provided theme to create a partial path' do
          Dir.stub(:glob).and_return([File.join(Rails.root, 'app', 'views', 'with_filters', 'foo', 'filter', '_base.html.erb')])

          filter = described_class.new(:first_name, :foo, 'Aaron',
            theme: 'foo'
          )

          expect(filter.to_partial_path).to eq File.join('with_filters', 'foo', 'filter', 'base')
        end

        it 'falls back to the original partials if the theme version can not be found' do
          Dir.stub(:glob).and_return([])

          filter = described_class.new(:first_name, :foo, 'Aaron',
            theme: 'foo'
          )

          expect(filter.to_partial_path).to eq File.join('with_filters', 'filter', 'base')
        end
      end

      context 'everything else' do
        it 'gets put in attrs' do
          filter = described_class.new(:first_name, :foo, 'Aaron',
            label: 'Given Name',
            class: 'input_class'
          )
          
          expect(filter.attrs).to eq({class: 'input_class'})
        end
      end
    end
  end
end
