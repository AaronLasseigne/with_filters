require 'spec_helper'

describe WithFilters::Filter::CheckBox do
  describe '#initialize(name, namespace, value, options = {})' do
    context 'without collection' do
      subject { described_class.new(:active, :foo, 'on') }

      its(:to_partial_path) { should == 'with_filters/filter/check_box' }

      context 'and value is "on"' do
        its(:selected?) { should be_true }
      end

      context 'and value is "off"' do
        subject { described_class.new(:active, :foo, 'off') }

        its(:selected?) { should be_false }
      end
    end

    context 'with collection' do
      let(:collection) { [
        'Chemistry', 'Literature', 'Peace', 'Physics', 'Physiology or Medicine'
      ] }
      subject do
        described_class.new(:categories, :foo, %w(Chemistry Physics),
          collection: collection
        )
      end

      its(:to_partial_path) { should == 'with_filters/filter/check_boxes' }

      context 'and there are values' do
        its(:selected?) { should be_true }
      end

      context 'and there are not values' do
        subject do
          described_class.new(:categories, :foo, [],
            collection: collection
          )
        end

        its(:selected?) { should be_false }
      end
    end
  end
end
