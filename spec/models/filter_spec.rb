require 'spec_helper'

describe WithFilters::Filter do
  describe '#create(name, namespace, value, options = {})' do
    context 'defaults' do
      context ':choices' do
        subject {described_class.create(:gender, :foo, 'Male', choices: ['Male', 'Female'])}

        it 'returns a select filter' do
          subject.should be_an_instance_of(WithFilters::Filter::Select)
        end
      end

      context 'no :choices' do
        subject {described_class.create(:first_name, :foo, 'Aaron')}

        it 'returns a text filter' do
          subject.should be_an_instance_of(WithFilters::Filter::Text)
        end
      end
    end

    context 'options' do
      context ':as' do
        subject {described_class.create(:email, :foo, '', as: :email)}

        it 'sets the input type' do
          subject.attrs.has_key?(:type).should be_true
          subject.attrs[:type].should == 'email'
        end

        it 'returns a filter based on the type' do
          subject.should be_an_instance_of(WithFilters::Filter::Text)
        end
      end
    end
  end
end
