require 'spec_helper'

describe WithFilters::ValuePrep::BooleanPrep do
  describe '#value' do
    it 'turns "on" into `true`' do
      described_class.new('on').value.should be true
    end

    it 'turns "off" into `false`' do
      described_class.new('off').value.should be false
    end
  end
end
