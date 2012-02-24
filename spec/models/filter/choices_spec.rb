require 'spec_helper'

describe WithFilters::Filter::Choices do
  describe '#initialize(choices, options = {})' do
    context 'choices are an Array ([1,2,3])' do
      let(:values) {[1,2,3]}
      subject {described_class.new(values)}

      it 'should create Choice objects' do
        values.each_with_index do |v, i|
          subject[i].label.should == v.to_s
          subject[i].value.should == v
        end
      end
    end

    context 'choices are an Array of Arrays ([[:one, 1], [:two, 2], [:three, 3]])' do
      let(:values) {[[:one, 1], [:two, 2], [:three, 3]]}
      subject {described_class.new(values)}

      it 'should create Choice objects' do
        values.each_with_index do |a, i|
          k, v = a
          subject[i].label.should == k.to_s
          subject[i].value.should == v
        end
      end
    end

    context 'choices are an Array of Arrays with options ([[:one, 1], [:two, 2, {class: "foo"}], [:three, 3]])' do
      let(:values) {[[:one, 1], [:two, 2, {class: 'foo'}], [:three, 3]]}
      subject {described_class.new(values)}

      it 'should create Choice objects' do
        values.each_with_index do |a, i|
          k, v = a
          subject[i].label.should == k.to_s
          subject[i].value.should == v
          if i == 1
            subject[i].attrs.should == {class: 'foo'}
          end
        end
      end
    end

    context 'choices are a Range (1..3)' do
      let(:values) {1..3}
      subject {described_class.new(values)}

      it 'should create Choice objects' do
        values.to_a.each_with_index do |v, i|
          subject[i].label.should == v.to_s
          subject[i].value.should == v
        end
      end
    end

    context 'choices are a Hash ({one: 1, two: 2, three: 3})' do
      let(:values) {{one: 1, two: 2, three: 3}}
      subject {described_class.new(values)}

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
