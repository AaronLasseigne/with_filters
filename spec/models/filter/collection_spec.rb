require 'spec_helper'

describe WithFilters::Filter::Collection do
  describe '#initialize(field_name, choices, options = {})' do
    context 'choices' do
      context 'is an Array ([1,2,3])' do
        let(:values)     { %w(1 2 3) }
        subject(:filter) { described_class.new('field', values) }

        it 'creates Choice objects' do
          values.each_with_index do |v, i|
            expect(filter[i].label).to eq v.to_s
            expect(filter[i].value).to eq v
          end
        end
      end

      context 'is an Array of Arrays ([[:one, 1], [:two, 2], [:three, 3]])' do
        let(:values)     { [[:one, 1], [:two, 2], [:three, 3]] }
        subject(:filter) { described_class.new('field', values) }

        it 'creates Choice objects' do
          values.each_with_index do |a, i|
            k, v = a

            expect(filter[i].label).to eq k.to_s
            expect(filter[i].value).to eq v
          end
        end
      end

      context 'is an Array of Arrays with options ([[:one, 1], [:two, 2, {class: "foo"}], [:three, 3]])' do
        let(:values)     { [[:one, 1], [:two, 2, {class: 'foo'}], [:three, 3]] }
        subject(:filter) { described_class.new('field', values) }

        it 'creates Choice objects' do
          values.each_with_index do |a, i|
            k, v = a

            expect(filter[i].label).to eq k.to_s
            expect(filter[i].value).to eq v
            expect(filter[i].attrs[:class]).to eq 'foo' if i == 1
          end
        end
      end

      context 'is a Range (1..3)' do
        let(:values)     { 1..3 }
        subject(:filter) { described_class.new('field', values) }

        it 'creates Choice objects' do
          values.to_a.each_with_index do |v, i|
            expect(filter[i].label).to eq v.to_s
            expect(filter[i].value).to eq v
          end
        end
      end

      context 'is a Hash ({one: 1, two: 2, three: 3})' do
        let(:values)     { {one: 1, two: 2, three: 3} }
        subject(:filter) { described_class.new('field', values) }

        it 'creates Choice objects' do
          i = 0
          values.each do |k, v|
            expect(filter[i].label).to eq k.to_s
            expect(filter[i].value).to eq v

            i += 1
          end
        end
      end
    end
  end
end
