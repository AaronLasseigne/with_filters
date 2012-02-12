require 'spec_helper'

describe 'WithFilters::ValuePrep::DatePrep' do
  describe '#value' do
    before do
      @column = NobelPrizeWinner.columns.detect{|c| c.name == 'birthdate'}
    end

    context 'value is a String' do
      it 'returns a Date' do
        WithFilters::ValuePrep::DatePrep.new(@column, '19140325').value.class == Date
      end
    end

    context 'value is an Array' do
      it 'returns an array of Date objects' do
        WithFilters::ValuePrep::DatePrep.new(@column, ['19140325', '19140326']).value.each do |v|
          v.class == Date
        end
      end
    end

    context 'value is a Hash' do
      it 'returns a Hash of Date objects' do
        value = WithFilters::ValuePrep::DatePrep.new(@column, {start: '19140325', stop: '19140326'}).value

        value[:start].class == Date
        value[:stop].class == Date
      end
    end
  end
end
