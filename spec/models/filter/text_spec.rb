require 'spec_helper'

describe WithFilters::Filter::Text do
  it 'should look for a partial based on the input type and use it if found' do
    described_class.new(:email, :foo, '').to_partial_path.should == 'with_filters/filter/text'
  end

  it 'should look for a partial based on the input type and use the default if it is not found' do
    # there must be a better way to do this
    Dir.stub!(:glob).and_return(['file'])

    described_class.new(:email, :foo, '', type: :email).to_partial_path.should == 'with_filters/filter/text_as_email'
  end
end
