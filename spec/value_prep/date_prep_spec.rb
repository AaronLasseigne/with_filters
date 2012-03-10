require 'spec_helper'

describe WithFilters::ValuePrep::DatePrep do
  describe '#value' do
    context 'value is a String' do
      it 'returns a Date' do
        described_class.new('19140325').value.should be_an_instance_of(Date)
      end
    end

    context 'value is an Array' do
      it 'returns an array of Date objects' do
        described_class.new(['19140325', '19140326']).value.each do |v|
          v.should be_an_instance_of(Date)
        end
      end
    end

    context 'value is a Hash' do
      it 'returns a Hash of Date objects' do
        value = described_class.new({start: '19140325', stop: '19140326'}).value

        value[:start].should be_an_instance_of(Date)
        value[:stop].should be_an_instance_of(Date)
      end
    end
  end
end
