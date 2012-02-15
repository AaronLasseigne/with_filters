require 'spec_helper'

describe WithFilters::ValuePrep::DefaultPrep do
  let(:column) {NobelPrize.columns.detect{|c| c.name == 'first_name'}}

  describe '#prepare_value' do
    it 'trims whitespace' do
      described_class.new(column, ' Albert ').prepare_value('Albert').should == 'Albert'
    end
  end

  describe '#add_match' do
    it 'returns an :exact match' do
      described_class.new(column, 'a', {match: :exact}).add_match('a').should == 'a'
    end

    it 'returns a :contains match' do
      described_class.new(column, 'a', {match: :contains}).add_match('a').should == '%a%'
    end

    it 'returns a :contains match' do
      described_class.new(column, 'a', {match: :begins_with}).add_match('a').should == 'a%'
    end

    it 'returns a :contains match' do
      described_class.new(column, 'a', {match: :ends_with}).add_match('a').should == '%a'
    end

    it 'defaults to :exact' do
      described_class.new(column, 'a').add_match('a').should == 'a'
    end
  end

  describe '#value' do
    context 'value is an Array' do
      it 'returns a string if only one value exists' do
        described_class.new(column, ['Albert']).value.should == 'Albert'
      end
    end
  end
end
