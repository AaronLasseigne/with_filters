require 'spec_helper'

describe WithFilters::Filter do
  context 'defaults' do
    subject {described_class.new(:first_name, :foo)}

    its(:to_partial_path) {should == 'with_filters/filter'}
    its(:label)           {should == 'First Name'}
    its(:field_name)      {should == 'foo[first_name]'}
  end
end
