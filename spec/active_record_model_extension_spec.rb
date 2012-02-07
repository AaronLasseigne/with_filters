require 'spec_helper'

describe 'WithFilters::ActiveRecordModelExtention' do
  describe '#with_filters(params)' do
    it 'does not break the chain' do
      npw = NobelPrizeWinner.with_filters({}).limit(1)
      npw.length.should == 1
    end
  end
end
