require 'spec_helper'

describe WithFilters::Filter::Collection do
  describe '#initialize(field_name, choices, options = {})' do
    context 'choices' do
      context 'is an Array ([1,2,3])' do
        let(:values) {[1,2,3]}
        subject {described_class.new('field', values)}

        it 'should create Choice objects' do
          values.each_with_index do |v, i|
            subject[i].label.should == v.to_s
            subject[i].value.should == v
          end
        end
      end

      context 'is an Array of Arrays ([[:one, 1], [:two, 2], [:three, 3]])' do
        let(:values) {[[:one, 1], [:two, 2], [:three, 3]]}
        subject {described_class.new('field', values)}

        it 'should create Choice objects' do
          values.each_with_index do |a, i|
            k, v = a
            subject[i].label.should == k.to_s
            subject[i].value.should == v
          end
        end
      end

      context 'is an Array of Arrays with options ([[:one, 1], [:two, 2, {class: "foo"}], [:three, 3]])' do
        let(:values) {[[:one, 1], [:two, 2, {class: 'foo'}], [:three, 3]]}
        subject {described_class.new('field', values)}

        it 'should create Choice objects' do
          values.each_with_index do |a, i|
            k, v = a
            subject[i].label.should == k.to_s
            subject[i].value.should == v
            subject[i].attrs[:class].should == 'foo' if i == 1
          end
        end
      end

      context 'is a Range (1..3)' do
        let(:values) {1..3}
        subject {described_class.new('field', values)}

        it 'should create Choice objects' do
          values.to_a.each_with_index do |v, i|
            subject[i].label.should == v.to_s
            subject[i].value.should == v
          end
        end
      end

      context 'is a Hash ({one: 1, two: 2, three: 3})' do
        let(:values) {{one: 1, two: 2, three: 3}}
        subject {described_class.new('field', values)}

        it 'should create Choice objects' do
          i = 0
          values.each do |k, v|
            subject[i].label.should == k.to_s
            subject[i].value.should == v
            i += 1
          end
        end
      end
    end
  end
end
