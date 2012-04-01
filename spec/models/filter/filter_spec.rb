require 'spec_helper'

describe WithFilters::Filter do
  describe '#create(name, namespace, value, options = {})' do
    context 'options' do
      context ':as' do
        subject {described_class.create(:email, :foo, '', as: :email)}

        it 'sets the input type' do
          subject.attrs[:type].should == 'email'
        end

        it 'returns a filter based on the type' do
          subject.should be_an_instance_of(WithFilters::Filter::Text)
        end
      end
    end
  end

  describe '#create_range(name, namespace, value, options = {})' do
    context 'options' do
      context ':as' do
        subject {described_class.create_range(:year, :foo, {}, as: :number)}

        it 'sets the input type' do
          subject.attrs[:type].should == 'number'
        end

        it 'returns a filter based on the type' do
          subject.should be_an_instance_of(WithFilters::Filter::TextRange)
        end
      end
    end
  end
end
