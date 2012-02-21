require 'spec_helper'

describe WithFilters::Filter do
  describe '#create(name, namespace, options = {})' do
    it 'returns a filter' do
      described_class.create(:first_name, :foo).should be_a_kind_of(WithFilters::Filter::Base)
    end
  end
end
