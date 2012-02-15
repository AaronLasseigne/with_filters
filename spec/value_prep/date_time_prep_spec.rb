require 'spec_helper'

describe WithFilters::ValuePrep::DateTimePrep do
  describe '#value' do
    let(:column) {NobelPrizeWinner.columns.detect{|c| c.name == 'created_at'}}

    context 'value is a String' do
      context 'value is a datetime' do
        let(:datetime) {'1914-03-25 12:34:56'}
        subject {described_class.new(column, datetime)}

        context 'database does not have decimal seconds' do
          it 'returns a value' do
            subject.stub!(:has_decimal_seconds?).and_return(false)

            subject.value.should == Time.zone.parse(datetime).to_s(:db)
          end
        end

        context 'database has decimal seconds' do
          it 'returns a value' do
            subject.stub!(:has_decimal_seconds?).and_return(true)

            subject.value.should == Time.zone.parse(datetime).to_s(:db) + '%'
          end
        end
      end

      context 'value is a date' do
        it 'returns a value' do
          date = '1914-03-25'
          described_class.new(column, date).value.should == date + '%'
        end
      end
    end

    context 'value is a Hash' do
      context 'value is a datetime range' do
        let(:datetimes) {{start: '1914-03-25 12:34:56', stop: '1914-03-26 12:34:56'}}
        subject {described_class.new(column, datetimes)}

        context 'database does not have decimal seconds' do
          it 'returns a Hash of values' do
            subject.stub!(:has_decimal_seconds?).and_return(false)

            subject.value[:start].should == Time.zone.parse(datetimes[:start]).to_s(:db)
            subject.value[:stop].should == Time.zone.parse(datetimes[:stop]).to_s(:db)
          end
        end

        context 'database has decimal seconds' do
          it 'returns a Hash of values' do
            subject.stub!(:has_decimal_seconds?).and_return(true)

            subject.value[:start].should == Time.zone.parse(datetimes[:start]).to_s(:db)
            subject.value[:stop].should == Time.zone.parse(datetimes[:stop]).advance(seconds: 1).to_s(:db)
          end
        end
      end

      context 'value is a date range' do
        it 'returns a Hash of values' do
          dates = {start: '19140325', stop: '19140326'}
          date_time_prep = described_class.new(column, dates)
          date_time_prep.stub!(:has_decimal_seconds?).and_return(false)

          date_time_prep.value[:start].should == Time.zone.parse(dates[:start] + '000000').to_s(:db)
          date_time_prep.value[:stop].should == Time.zone.parse(dates[:stop] + '235959').to_s(:db)
        end
      end
    end
  end
end
