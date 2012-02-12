require 'spec_helper'

describe 'WithFilters::ValuePrep::DateTimePrep' do
  describe '#value' do
    before(:all) do
      @column = NobelPrizeWinner.columns.detect{|c| c.name == 'created_at'}
    end

    context 'value is a String' do
      context 'value is a datetime' do
        before(:each) do
          @datetime = '1914-03-25 12:34:56'
          @date_time_prep = WithFilters::ValuePrep::DateTimePrep.new(@column, @datetime)
        end

        context 'database does not have decimal seconds' do
          it 'returns a value' do
            @date_time_prep.stub!(:has_decimal_seconds?).and_return(false)

            @date_time_prep.value.should == Time.zone.parse(@datetime).to_s(:db)
          end
        end

        context 'database has decimal seconds' do
          it 'returns a value' do
            @date_time_prep.stub!(:has_decimal_seconds?).and_return(true)

            @date_time_prep.value.should == Time.zone.parse(@datetime).to_s(:db) + '%'
          end
        end
      end

      context 'value is a date' do
        it 'returns a value' do
          date = '1914-03-25'
          WithFilters::ValuePrep::DateTimePrep.new(@column, date).value.should == date + '%'
        end
      end
    end

    context 'value is a Hash' do
      context 'value is a datetime range' do
        before(:each) do
          @datetimes = {start: '1914-03-25 12:34:56', stop: '1914-03-26 12:34:56'}
          @date_time_prep = WithFilters::ValuePrep::DateTimePrep.new(@column, @datetimes)
        end

        context 'database does not have decimal seconds' do
          it 'returns a Hash of values' do
            @date_time_prep.stub!(:has_decimal_seconds?).and_return(false)

            @date_time_prep.value[:start].should == Time.zone.parse(@datetimes[:start]).to_s(:db)
            @date_time_prep.value[:stop].should == Time.zone.parse(@datetimes[:stop]).to_s(:db)
          end
        end

        context 'database has decimal seconds' do
          it 'returns a Hash of values' do
            @date_time_prep.stub!(:has_decimal_seconds?).and_return(true)

            @date_time_prep.value[:start].should == Time.zone.parse(@datetimes[:start]).to_s(:db)
            @date_time_prep.value[:stop].should == Time.zone.parse(@datetimes[:stop]).advance(seconds: 1).to_s(:db)
          end
        end
      end

      context 'value is a date range' do
        it 'returns a Hash of values' do
          dates = {start: '19140325', stop: '19140326'}
          date_time_prep = WithFilters::ValuePrep::DateTimePrep.new(@column, dates)
          date_time_prep.stub!(:has_decimal_seconds?).and_return(false)

          date_time_prep.value[:start].should == Time.zone.parse(dates[:start] + '000000').to_s(:db)
          date_time_prep.value[:stop].should == Time.zone.parse(dates[:stop] + '235959').to_s(:db)
        end
      end
    end
  end
end
