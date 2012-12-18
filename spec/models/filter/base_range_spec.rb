require 'spec_helper'

describe WithFilters::Filter::BaseStart do
  subject { described_class.new(:year, :foo, '') }

  its(:field_name) { should == 'foo[year][start]' }
end

describe WithFilters::Filter::BaseStop do
  subject { described_class.new(:year, :foo, '') }

  its(:field_name) { should == 'foo[year][stop]' }
end

describe WithFilters::Filter::BaseRange do
  subject { described_class.new(:year, :foo, {}) }

  its(:start) { should be_an_instance_of(WithFilters::Filter::BaseStart) }
  its(:stop)  { should be_an_instance_of(WithFilters::Filter::BaseStop) }

  context 'options' do
    it 'uses the :start and :stop option hashes for the individual filters and default any values not passed to the range options provided' do
      filter = described_class.new(:year, :foo, {}, label: 'Nobel Prize Won In')
      expect(filter.stop.label).to eq 'Nobel Prize Won In'

      filter = described_class.new(:year, :foo, {},
       label: 'Nobel Prize Won In',
       start: {label: 'Nobel Prize Won Between'},
       stop:  {label: 'and'}
      )
      expect(filter.start.label).to eq 'Nobel Prize Won Between'
      expect(filter.stop.label).to eq 'and'
    end
  end
end
