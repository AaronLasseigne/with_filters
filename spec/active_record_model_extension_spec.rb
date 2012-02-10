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
          npw = NobelPrizeWinner.with_filters({nobel_prize_winners: {filter: {first_name: ['Albert', '']}}})
          npw.length.should == 1
          npw.first.first_name.should == 'Albert'
          npw.where_values.should == ["nobel_prize_winners.\"first_name\" IN('Albert')"]
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

      context 'field value is a boolean (and the column on the table is a :boolean)' do
        it 'filters when "true" and "false" are passed' do
          np = NobelPrize.with_filters({nobel_prizes: {filter: {shared: 'true'}}})
          np.length.should == 7

          np = NobelPrize.with_filters({nobel_prizes: {filter: {shared: 'false'}}})
          np.length.should == 9
        end
      end

      context 'field value is a date (and the column on the table is a :date)' do
        it 'filters on the date value' do
          npw = NobelPrizeWinner.with_filters({nobel_prize_winners: {filter: {birthdate: '19140325'}}})
          npw.length.should == 1
          npw.first.birthdate.should == '19140325'.to_date
        end
      end

      context 'field value is a date range (and the column on the table is a :date)' do
        it 'filters between :start and :stop' do
          npw = NobelPrizeWinner.
            with_filters({nobel_prize_winners: {filter: {birthdate: {start: '19140325', stop: '19280406'}}}}).
            order('birthdate ASC')
          npw.length.should == 4
          npw.first.birthdate.should == '19140325'.to_date
          npw.last.birthdate.should == '19280406'.to_date
        end
      end

      context 'field value is a datetime (and the column on the table is a :datetime or :timestamp)' do
        it 'filters on the datetime value' do
          npw = NobelPrizeWinner.with_filters({nobel_prize_winners: {filter: {updated_at: '20120207170905'}}})
          npw.length.should == 1
          npw.first.updated_at.to_s.should == Time.parse('20120207170905').to_s
        end
      end

      context 'field value is a datetime range (and the column on the table is a :datetime or :timestamp)' do
        it 'filters between :start and :stop' do
          npw = NobelPrizeWinner.
            with_filters({nobel_prize_winners: {filter: {updated_at: {start: '20120207170905', stop: '20120207170908'}}}}).
            order('updated_at ASC')
          npw.length.should == 4
          npw.first.updated_at.to_s.should == Time.parse('20120207170905').to_s
          npw.last.updated_at.to_s.should == Time.parse('20120207170908').to_s
        end
      end

      it 'accepts more than one field' do
        np = NobelPrize.with_filters({nobel_prizes: {filter: {year: {start: 1900, stop: 1930}, category: 'Physics'}}})
        np.length.should == 3
      end
    end

    context 'limit the need for specifying table names to resolve ambiguity' do
      it 'prepends the table name to the field if the field is in the primary table' do
        npw = NobelPrizeWinner.joins(:nobel_prizes).with_filters({nobel_prize_winners: {filter: {birthdate: '19140325'}}})
        npw.where_values.first.should =~ /^#{npw.table_name}\./
      end 

      it 'does not affect non-primary fields' do
        npw = NobelPrizeWinner.joins(:nobel_prizes).with_filters({nobel_prize_winners: {filter: {year: '1903'}}})
        npw.where_values.first.should =~ /^#{npw.connection.quote_column_name('year')}/
      end 
    end

    it 'quotes column names' do
      npw = NobelPrizeWinner.joins(:nobel_prizes).with_filters({nobel_prize_winners: {filter: {year: '1903'}}})
      npw.where_values.first.should =~ /^#{npw.connection.quote_column_name('year')}/
    end

    it 'does not break the chain' do
      npw = NobelPrizeWinner.with_filters.limit(1)
      npw.length.should == 1
    end
  end
end
