require 'spec_helper'

describe 'WithFilters::ValuePrep::DefaultPrep' do
  describe '#value' do
    before do
      @column = NobelPrize.columns.detect{|c| c.name == 'first_name'}
    end

    context 'value is a String' do
      it 'trims whitespace' do
        WithFilters::ValuePrep::DefaultPrep.new(@column, ' Albert ').value.should == 'Albert'
      end
    end

    context 'value is an Array' do
      it 'trims whitespace' do
        WithFilters::ValuePrep::DefaultPrep.new(@column, [' Albert ', ' Marie ']).value.should == ['Albert', 'Marie']
      end

      it 'returns a string if only one value exists' do
        WithFilters::ValuePrep::DefaultPrep.new(@column, ['Albert']).value.should == 'Albert'
      end
    end

    context 'value is a Hash' do
      it 'trims whitespace' do
        value = WithFilters::ValuePrep::DefaultPrep.new(@column, {start: ' Albert ', stop: ' Marie '}).value
        
        value[:start].should == 'Albert'
        value[:stop].should == 'Marie'
      end
    end
  end
end
