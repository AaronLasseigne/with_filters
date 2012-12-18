require 'spec_helper'

describe WithFilters::Filter::Select do
  describe '#initialize(name, namespace, value, options = {})' do
    context 'options' do
      it 'allows :collection to accept a string' do
        filter = described_class.new(:gender, :foo, 'Male',
          collection: '<option>Male</option><option>Female</option>'
        )

        expect(filter.collection).to eq '<option selected="selected">Male</option><option>Female</option>'
      end
    end
  end
end
