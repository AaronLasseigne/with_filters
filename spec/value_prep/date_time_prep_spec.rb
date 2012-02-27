require 'spec_helper'

describe WithFilters::ValuePrep::DateTimePrep do
  describe '#value' do
    let(:column) {NobelPrizeWinner.columns.detect{|c| c.name == 'created_at'}}

    context 'is a String' do
      context 'representing a datetime' do
        context 'with decimal seconds' do
          it 'returns a value' do
            datetime = '1914-03-25 12:34:56.123456'
            described_class.new(column, datetime).value.should == Time.zone.parse(datetime).to_s(:db) + '.123456'
          end
        end

        context 'without decimal seconds' do
          it 'returns a value' do
            datetime = '1914-03-25 12:34:56'
            value = described_class.new(column, datetime).value
            
            value[:start].should == Time.zone.parse(datetime).to_s(:db) + '.000000'
            value[:stop].should  == Time.zone.parse(datetime).to_s(:db) + '.999999'
          end
        end
      end

      context 'representing a date' do
        it 'returns a value' do
          date = '1914-03-25'
          value = described_class.new(column, date).value

          value[:start].should == Time.zone.parse(date + ' 00:00:00').to_s(:db) + '.000000'
          value[:stop].should  == Time.zone.parse(date + ' 23:59:59').to_s(:db) + '.999999'
        end
      end
    end

    context 'is a Hash' do
      context 'representing a datetime range' do
        context 'with decimal seconds' do
          it 'returns a Hash of values' do
            datetimes = {start: '1914-03-25 12:34:56.123456', stop: '1914-03-26 12:34:56.654321'}
            value = described_class.new(column, datetimes).value

            value[:start].should == Time.zone.parse(datetimes[:start]).to_s(:db) + '.123456'
            value[:stop].should  == Time.zone.parse(datetimes[:stop]).to_s(:db) + '.654321'
          end
        end

        context 'without decimal seconds' do
          it 'returns a Hash of values' do
            datetimes = {start: '1914-03-25 12:34:56', stop: '1914-03-26 12:34:56'}
            value = described_class.new(column, datetimes).value

            value[:start].should == Time.zone.parse(datetimes[:start]).to_s(:db) + '.000000'
            value[:stop].should  == Time.zone.parse(datetimes[:stop]).to_s(:db) + '.999999'
          end
        end
      end

      context 'representing a date range' do
        it 'returns a Hash of values' do
          dates = {start: '19140325', stop: '19140326'}
          date_time_prep = described_class.new(column, dates)
          date_time_prep.stub!(:has_decimal_seconds?).and_return(false)

          date_time_prep.value[:start].should == Time.zone.parse(dates[:start] + '000000').to_s(:db) + '.000000'
          date_time_prep.value[:stop].should  == Time.zone.parse(dates[:stop] + '235959').to_s(:db) + '.999999'
        end
      end
    end
  end
end
