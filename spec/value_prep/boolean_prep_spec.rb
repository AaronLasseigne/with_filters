require 'spec_helper'

describe WithFilters::ValuePrep::BooleanPrep do
  describe '#value' do
    let(:column) {NobelPrize.columns.detect{|c| c.name == 'shared'}}

    it 'turns "true" into `true`' do
      described_class.new(column, 'true').value.should be true
    end

    it 'turns "false" into `false`' do
      described_class.new(column, 'false').value.should be false
    end
  end
end
