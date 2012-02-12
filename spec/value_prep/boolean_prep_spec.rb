require 'spec_helper'

describe 'WithFilters::ValuePrep::BooleanPrep' do
  describe '#value' do
    before do
      @column = NobelPrize.columns.detect{|c| c.name == 'shared'}
    end

    it 'turns "true" into a TrueClass boolean' do
      WithFilters::ValuePrep::BooleanPrep.new(@column, 'true').value.should == true
    end

    it 'turns "false" into a FalseClass boolean' do
      WithFilters::ValuePrep::BooleanPrep.new(@column, 'false').value.should == false
    end
  end
end
