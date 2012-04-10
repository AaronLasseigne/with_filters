require 'spec_helper'

describe WithFilters::Filter::Select do
  describe '#initialize(name, namespace, value, options = {})' do
    context 'options' do
      it 'allows :collection to accept a string' do
        subject = described_class.new(:gender, :foo, 'Male', collection: '<option>Male</option><option>Female</option>')
        subject.collection.should == '<option selected="selected">Male</option><option>Female</option>'
      end
    end
  end
end
