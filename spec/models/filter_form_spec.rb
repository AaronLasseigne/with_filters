require 'spec_helper'

describe WithFilters::FilterForm do
  describe '#initialize(records, options = {})' do
    context 'defaults' do
      subject {described_class.new(NobelPrizeWinner.all)}

      its(:attrs)           {should == {novalidate: 'novalidate', method: 'get'}}
      its(:to_partial_path) {should == 'with_filters/filter_form'}
      its(:filters)         {should be_empty}
    end

    context 'options' do
      context ':attrs' do
        it 'attrs should override the defaults' do
          described_class.new(NobelPrizeWinner.all, {method: 'post'}).attrs.should == {novalidate: 'novalidate', method: 'post'}
        end
      end
    end
  end

  describe '#input(name, options = {})' do
    it 'adds a filter' do
      label = 'Given Name'
      ff = described_class.new(NobelPrizeWinner.with_filters.all)
      ff.input(:first_name, label: label)

      ff.filters.length.should == 1
      ff.filters.first.should be_an_instance_of(WithFilters::Filter)
      ff.filters.first.label.should == label
    end
  end
end
