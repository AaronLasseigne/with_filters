require 'spec_helper'

describe WithFilters::ValuePrep::DefaultPrep do
  describe '#value' do
    context '#initialize value is a String' do
      it 'trims whitespace' do
        described_class.new(' Albert ').value.should == 'Albert'
      end

      context '#initialize options' do
        context ':match' do
          it 'returns an :exact match' do
            described_class.new('a', {match: :exact}).value.should == 'a'
          end

          it 'returns a :contains match' do
            described_class.new('a', {match: :contains}).value.should == '%a%'
          end

          it 'returns a :begins_with match' do
            described_class.new('a', {match: :begins_with}).value.should == 'a%'
          end

          it 'returns an :ends_with match' do
            described_class.new('a', {match: :ends_with}).value.should == '%a'
          end
        end

        context 'no :match' do
          it 'defaults to :exact' do
            described_class.new('a').value.should == 'a'
          end
        end
      end
    end

    context '#initialize value is an Array' do
      it 'returns a string if only one value exists' do
        described_class.new(['Albert']).value.should == 'Albert'
      end
    end
  end
end
