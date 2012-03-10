require 'spec_helper'

describe WithFilters::ValuePrep::DateTimePrep do
  describe '#value' do
    context 'is a String representing a datetime' do
      context 'to a fraction of a second' do
        it 'returns a value' do
          datetime = '1914-03-25 12:34:56.123456'
          described_class.new(datetime).value.should == Time.zone.parse(datetime).to_s(:db) + '.123456'
        end
      end

      context 'to a second' do
        it 'returns a value' do
          datetime = '1914-03-25 12:34:56'
          value = described_class.new(datetime).value
          
          value[:start].should == Time.zone.parse(datetime).to_s(:db)
          value[:stop].should  == Time.zone.parse(datetime).advance(seconds: 1).to_s(:db)
        end
      end

      context 'to a minute' do
        it 'returns a value' do
          datetime = '1914-03-25 12:34'
          value = described_class.new(datetime).value
          
          value[:start].should == Time.zone.parse(datetime).to_s(:db)
          value[:stop].should  == Time.zone.parse(datetime).advance(minutes: 1).to_s(:db)
        end
      end

      context 'to an hour' do
        it 'returns a value' do
          datetime = '1914-03-25 12'
          value = described_class.new(datetime).value
          
          value[:start].should == Time.zone.parse(datetime).to_s(:db)
          value[:stop].should  == Time.zone.parse(datetime).advance(hours: 1).to_s(:db)
        end
      end

      context 'to a day' do
        it 'returns a value' do
          date = '1914-03-25'
          value = described_class.new(date).value

          value[:start].should == Time.zone.parse(date).to_s(:db)
          value[:stop].should  == Time.zone.parse(date).advance(days: 1).to_s(:db)
        end
      end
    end

    context 'is a Hash representing a datetime range' do
      context 'to a fraction of a second' do
        it 'returns a Hash of values' do
          datetimes = {start: '1914-03-25 12:34:56.123456', stop: '1914-03-26 12:34:56.654321'}
          value = described_class.new(datetimes).value

          value[:start].should == Time.zone.parse(datetimes[:start]).to_s(:db) + '.123456'
          value[:stop].should  == Time.zone.parse(datetimes[:stop]).to_s(:db) + '.654321'
        end
      end

      context 'to a second' do
        it 'returns a Hash of values' do
          datetimes = {start: '1914-03-25 12:34:56', stop: '1914-03-26 12:34:56'}
          value = described_class.new(datetimes).value

          value[:start].should == Time.zone.parse(datetimes[:start]).to_s(:db)
          value[:stop].should  == Time.zone.parse(datetimes[:stop]).advance(seconds: 1).to_s(:db)
        end
      end

      context 'to a minute' do
        it 'returns a Hash of values' do
          datetimes = {start: '1914-03-25 12:34', stop: '1914-03-26 12:34'}
          value = described_class.new(datetimes).value

          value[:start].should == Time.zone.parse(datetimes[:start]).to_s(:db)
          value[:stop].should  == Time.zone.parse(datetimes[:stop]).advance(minutes: 1).to_s(:db)
        end
      end

      context 'to an hour' do
        it 'returns a Hash of values' do
          datetimes = {start: '1914-03-25 12', stop: '1914-03-26 12'}
          value = described_class.new(datetimes).value

          value[:start].should == Time.zone.parse(datetimes[:start]).to_s(:db)
          value[:stop].should  == Time.zone.parse(datetimes[:stop]).advance(hours: 1).to_s(:db)
        end
      end

      context 'to a day' do
        it 'returns a Hash of values' do
          dates = {start: '19140325', stop: '19140326'}
          date_time_prep = described_class.new(dates)

          date_time_prep.value[:start].should == Time.zone.parse(dates[:start]).to_s(:db)
          date_time_prep.value[:stop].should  == Time.zone.parse(dates[:stop]).advance(days: 1).to_s(:db)
        end
      end
    end
  end
end
