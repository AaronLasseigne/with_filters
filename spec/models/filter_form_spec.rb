require 'spec_helper'

describe WithFilters::FilterForm do
  describe '#initialize(records, params = {}, options = {})' do
    context 'defaults' do
      subject {described_class.new(NobelPrizeWinner.with_filters)}

      its(:attrs)           {should == {novalidate: 'novalidate', method: 'get'}}
      its(:to_partial_path) {should == 'with_filters/filter_form'}
      its(:filters)         {should be_empty}
      its(:param_namespace) {should == :nobel_prize_winners}
    end

    context 'options' do
      context ':attrs' do
        it 'attrs should override the defaults' do
          described_class.new(NobelPrizeWinner.with_filters, {}, {method: 'post'}).attrs.should == {novalidate: 'novalidate', method: 'post'}
        end
      end
    end
  end

  describe '#input(name, options = {})' do
    it 'adds a filter' do
      label = 'Given Name'
      ff = described_class.new(NobelPrizeWinner.with_filters)
      ff.input(:first_name, label: label)

      ff.filters.length.should == 1
      ff.filters.first.should be_a_kind_of(WithFilters::Filter::Base)
      ff.filters.first.label.should == label
    end

    let(:ff) {described_class.new(FieldFormatTester.with_filters)}

    context 'the database field is an integer, float or decimal' do
      it 'uses a number filter' do
        ff.input(:integer_field)
        ff.input(:float_field)
        ff.input(:decimal_field)

        ff.filters[0].should be_a_kind_of(WithFilters::Filter::Text)
        ff.filters[0].attrs[:type].should == 'number'
        ff.filters[1].should be_a_kind_of(WithFilters::Filter::Text)
        ff.filters[1].attrs[:type].should == 'number'
        ff.filters[2].should be_a_kind_of(WithFilters::Filter::Text)
        ff.filters[2].attrs[:type].should == 'number'
      end
    end

    context 'the database field is a date' do
      it 'uses a date filter' do
        ff.input(:date_field)

        ff.filters.first.should be_a_kind_of(WithFilters::Filter::Text)
        ff.filters.first.attrs[:type].should == 'date'
      end
    end

    context 'the database field is a time' do
      it 'uses a time filter' do
        ff.input(:time_field)

        ff.filters.first.should be_a_kind_of(WithFilters::Filter::Text)
        ff.filters.first.attrs[:type].should == 'time'
      end
    end

    context 'the database field is a datetime or timestamp' do
      it 'uses a time filter' do
        ff.input(:datetime_field)
        ff.input(:timestamp_field)

        ff.filters[0].should be_a_kind_of(WithFilters::Filter::Text)
        ff.filters[0].attrs[:type].should == 'datetime'
        ff.filters[1].should be_a_kind_of(WithFilters::Filter::Text)
        ff.filters[1].attrs[:type].should == 'datetime'
      end
    end

    context 'the database field is a boolean' do
      it 'uses a checkbox filter' do
        ff.input(:boolean_field)

        ff.filters.first.should be_a_kind_of(WithFilters::Filter::CheckBox)
        ff.filters.first.attrs[:type].should == 'checkbox'
      end
    end

    context 'the database field is a text' do
      context 'and the name includes "email"' do
        it 'uses an email filter' do
          ff.input(:email_field)

          ff.filters.first.should be_a_kind_of(WithFilters::Filter::Text)
          ff.filters.first.attrs[:type].should == 'email'
        end
      end

      context 'and the name includes "phone"' do
        it 'uses a tel filter' do
          ff.input(:phone_field)

          ff.filters.first.should be_a_kind_of(WithFilters::Filter::Text)
          ff.filters.first.attrs[:type].should == 'tel'
        end
      end

      context 'and the name includes "url"' do
        it 'uses a url filter' do
          ff.input(:url_field)

          ff.filters.first.should be_a_kind_of(WithFilters::Filter::Text)
          ff.filters.first.attrs[:type].should == 'url'
        end
      end
    end

    context 'options' do
      context ':choices' do
        it 'defaults to a select filter' do
          ff = described_class.new(FieldFormatTester.with_filters)
          ff.input(:text_field)

          ff.filters.first.should be_a_kind_of(WithFilters::Filter::Text)
          ff.filters.first.attrs[:type].should == 'text'
        end
      end

      context 'no :choices' do
        it 'defaults to a select filter' do
          ff = described_class.new(FieldFormatTester.with_filters)
          ff.input(:text_field, choices: 1..10)

          ff.filters.first.should be_a_kind_of(WithFilters::Filter::Select)
        end
      end
    end
  end

  describe '#input_range(name, options = {})' do
    it 'adds a ranged filter' do
      label = 'Awarded'
      ff = described_class.new(NobelPrizeWinner.with_filters)
      ff.input_range(:year, label: label)

      ff.filters.length.should == 1
      ff.filters.first.should be_a_kind_of(WithFilters::Filter::BaseRange)
      ff.filters.first.start.label.should == label
    end
  end
end
