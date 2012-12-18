require 'spec_helper'

describe WithFilters::Filter::Text do
  it 'should look for a partial based on the input type and use it if found' do
    filter = described_class.new(:email, :foo, '')
    
    expect(filter.to_partial_path).to eq File.join('with_filters', 'filter', 'text')
  end

  it 'should look for a partial based on the input type and use the default if it is not found' do
    # there must be a better way to do this
    Dir.stub(:glob).and_return([File.join('with_filters', 'filter', '_text_as_email.html.erb')])
    filter = described_class.new(:email, :foo, '', type: :email)
    expect(filter.to_partial_path).to eq File.join('with_filters', 'filter', 'text_as_email')
    
    Dir.stub(:glob).and_return([])
    filter = described_class.new(:email, :foo, '', type: :email)
    expect(filter.to_partial_path).to eq File.join('with_filters', 'filter', 'text')
  end
end
