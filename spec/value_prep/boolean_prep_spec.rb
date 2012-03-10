require 'spec_helper'

describe WithFilters::ValuePrep::BooleanPrep do
  describe '#value' do
    it 'turns "true" into `true`' do
      described_class.new('true').value.should be true
    end

    it 'turns "false" into `false`' do
      described_class.new('false').value.should be false
    end
  end
end
