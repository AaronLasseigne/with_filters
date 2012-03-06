require 'spec_helper'

describe WithFilters::Filter::TextStart do
  subject {described_class.new(:year, :foo, '')}

  its(:field_name) {should == 'foo[year][start]'}
end

describe WithFilters::Filter::TextStop do
  subject {described_class.new(:year, :foo, '')}

  its(:field_name) {should == 'foo[year][stop]'}
end

describe WithFilters::Filter::TextRange do
  subject {described_class.new(:year, :foo, {})}

  its(:start) {should be_an_instance_of(WithFilters::Filter::TextStart)}
  its(:stop)  {should be_an_instance_of(WithFilters::Filter::TextStop)}

  context 'options' do
    it 'uses the :start and :stop option hashes for the individual filters and default any values not passed to the range options provided' do
      filter = described_class.new(:year, :foo, {}, label: 'Nobel Prize Won In')
      filter.start.label.should == 'Nobel Prize Won In'
      filter.stop.label.should  == 'Nobel Prize Won In'

      filter = described_class.new(:year, :foo, {}, label: 'Nobel Prize Won In', start: {label: 'Nobel Prize Won Between'}, stop: {label: 'and'})
      filter.start.label.should == 'Nobel Prize Won Between'
      filter.stop.label.should  == 'and'
    end
  end
end
