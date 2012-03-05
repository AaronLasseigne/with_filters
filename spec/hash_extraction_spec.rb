require 'spec_helper'

describe WithFilters::HashExtraction do
  describe '#extract_hash_value(hash, key)' do
    let(:params) {{
      'fizz' => 'buzz',
      foo:       'bar',
      one:      {two: {three: 3}}
    }}
    subject {
      class TestHashExtraction
        include WithFilters::HashExtraction
      end
      TestHashExtraction.new
    }

    context 'where a regular hash key is used' do
      context 'where the value is a Symbol' do
        it 'returns the value from the hash' do
          subject.extract_hash_value(params, :foo).should == params[:foo]
        end
      end

      context 'where the value is a String' do
        it 'returns the value from the hash' do
          subject.extract_hash_value(params, 'fizz').should == params['fizz']
        end
      end

      context 'where the value is not found' do
        it 'returns nil' do
          subject.extract_hash_value(params, 'yo').should be nil
        end
      end
    end

    context 'where a nested hash key is used' do
      it 'returns the value from the hash' do
        subject.extract_hash_value(params, 'one[:two][:three]').should == params[:one][:two][:three]
      end

      context 'where the value is not found' do
        it 'returns nil' do
          subject.extract_hash_value(params, 'yo[:one]').should be nil
        end
      end
    end
  end
end
