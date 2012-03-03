require 'spec_helper'

describe WithFilters::Filter::CheckBox do
  describe '#initialize(name, namespace, value, options = {})' do
    context 'without choices' do
      subject {described_class.new(:active, :foo, true)}

      its(:to_partial_path) {should == 'with_filters/filter/check_box'}

      context 'and value is true' do
        its(:selected?) {should be true}
      end

      context 'and value is false' do
        subject {described_class.new(:active, :foo, false)}
        its(:selected?) {should be false}
      end
    end

    context 'with choices' do
      let(:choices) {['Chemistry', 'Literature', 'Peace', 'Physics', 'Physiology or Medicine']}
      subject {described_class.new(:categories, :foo, ['Chemistry', 'Physics'], choices: choices)}

      its(:to_partial_path) {should == 'with_filters/filter/check_boxes'}

      context 'and there are values' do
        its(:selected?) {should be true}
      end

      context 'and there are not values' do
        subject {described_class.new(:categories, :foo, [], choices: choices)}
        its(:selected?) {should be false}
      end
    end
  end
end
