require 'spec_helper'

describe WithFilters::ValuePrep::DefaultPrep do
  describe '#prepare_value' do
    it 'trims whitespace' do
      described_class.new(' Albert ').prepare_value('Albert').should == 'Albert'
    end
  end

  describe '#add_match' do
    it 'returns an :exact match' do
      described_class.new('a', {match: :exact}).add_match('a').should == 'a'
    end

    it 'returns a :contains match' do
      described_class.new('a', {match: :contains}).add_match('a').should == '%a%'
    end

    it 'returns a :begins_with match' do
      described_class.new('a', {match: :begins_with}).add_match('a').should == 'a%'
    end

    it 'returns a :ends_with match' do
      described_class.new('a', {match: :ends_with}).add_match('a').should == '%a'
    end

    it 'defaults to :exact' do
      described_class.new('a').add_match('a').should == 'a'
    end
  end

  describe '#value' do
    context 'value is an Array' do
      it 'returns a string if only one value exists' do
        described_class.new(['Albert']).value.should == 'Albert'
      end
    end
  end
end
