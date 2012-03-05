require 'spec_helper'

describe WithFilters::Filter::Select do
  describe '#initialize(name, namespace, value, options = {})' do
    context 'options' do
      it 'allows :choices to accept a string' do
        subject = described_class.new(:gender, :foo, 'Male', choices: '<option>Male</option><option>Female</option>')
        subject.choices.should == '<option selected="selected">Male</option><option>Female</option>'
      end
    end
  end
end
