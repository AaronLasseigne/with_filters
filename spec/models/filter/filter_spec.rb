require 'spec_helper'

describe WithFilters::Filter do
  describe '#create(name, namespace, value, options = {})' do
    context 'options' do
      context ':as' do
        subject(:filter) do
          described_class.create(:email, :foo, '', as: :email)
        end

        it 'sets the input type' do
          expect(filter.attrs[:type]).to eq 'email'
        end

        it 'returns a filter based on the type' do
          expect(filter).to be_an_instance_of(WithFilters::Filter::Text)
        end
      end
    end
  end

  describe '#create_range(name, namespace, value, options = {})' do
    context 'options' do
      context ':as' do
        subject(:filter) do
          described_class.create_range(:year, :foo, {}, as: :number)
        end

        it 'sets the input type' do
          expect(filter.attrs[:type]).to eq 'number'
        end

        it 'returns a filter based on the type' do
          expect(filter).to be_an_instance_of(WithFilters::Filter::TextRange)
        end
      end
    end
  end
end
