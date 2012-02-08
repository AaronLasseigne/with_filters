require 'spec_helper'

describe 'WithFilters::ActiveRecordModelExtention' do
  describe '#with_filters(params = nil)' do
    context 'filters using fields' do
      context 'field value is a string' do
        it 'filters based on the string value' do
          npw = NobelPrizeWinner.with_filters({nobel_prize_winners: {filter: {first_name: 'Albert'}}})
          npw.length.should == 1
          npw.first.first_name.should == 'Albert'
        end

        it 'skips an empty value' do
          npw = NobelPrizeWinner.with_filters({nobel_prize_winners: {filter: {first_name: ''}}})
          npw.where_values.should == []
        end

        it 'trims whitespace' do
          npw = NobelPrizeWinner.with_filters({nobel_prize_winners: {filter: {first_name: ' Albert '}}})
          npw.length.should == 1
          npw.first.first_name.should == 'Albert'
        end
      end

      context 'field value is an array' do
        it 'filters based on the array values' do
          npw = NobelPrizeWinner.with_filters({nobel_prize_winners: {filter: {first_name: ['Albert', 'Marie']}}}).order('first_name ASC')
          npw.length.should == 2
          npw.first.first_name.should == 'Albert'
          npw.last.first_name.should == 'Marie'
        end

        it 'skips blank array values' do
          npw = NobelPrizeWinner.with_filters({nobel_prize_winners: {filter: {first_name: ['Albert', '']}}}).order('first_name ASC')
          npw.length.should == 1
          npw.first.first_name.should == 'Albert'
          npw.where_values.should == ["\"first_name\" IN('Albert')"]
        end

        it 'skips empty arrays' do
          npw = NobelPrizeWinner.with_filters({nobel_prize_winners: {filter: {first_name: []}}})
          npw.where_values.should == []
        end
      end

      context 'field value is a :start and :stop range' do
        it 'filters between :start and :stop' do
          np = NobelPrize.with_filters({nobel_prizes: {filter: {year: {start: 1900, stop: 1930}}}})
          np.length.should == 4
        end

        it 'discards the range if :start or :stop are emtpy' do
          np = NobelPrize.with_filters({nobel_prizes: {filter: {year: {start: 1900, stop: ''}}}})
          np.where_values.should == []

          np = NobelPrize.with_filters({nobel_prizes: {filter: {year: {stop: 1930}}}})
          np.where_values.should == []
        end
      end

      it 'accepts more than one field' do
        np = NobelPrize.with_filters({nobel_prizes: {filter: {year: {start: 1900, stop: 1930}, category: 'Physics'}}})
        np.length.should == 3
      end

      it 'works on boolean fields when "true" and "false" are passed' do
        np = NobelPrize.with_filters({nobel_prizes: {filter: {shared: 'true'}}})
        np.length.should == 7

        np = NobelPrize.with_filters({nobel_prizes: {filter: {shared: 'false'}}})
        np.length.should == 9
      end
    end

    it 'does not break the chain' do
      npw = NobelPrizeWinner.with_filters.limit(1)
      npw.length.should == 1
    end
  end
end
