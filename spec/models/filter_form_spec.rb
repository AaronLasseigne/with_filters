require 'spec_helper'

describe WithFilters::FilterForm do
  describe '#initialize(records, params = {}, options = {})' do
    context 'defaults' do
      subject {described_class.new(NobelPrizeWinner.with_filters)}

      its(:attrs)           {should == {novalidate: 'novalidate', method: 'get'}}
      its(:to_partial_path) {should == File.join('with_filters', 'filter_form')}
      its(:param_namespace) {should be :nobel_prize_winners}
      its(:filters)         {should be_empty}
      its(:hidden_filters)  {should be_empty}
      its(:actions)         {should be_empty}
    end

    context 'options' do
      context ':attrs' do
        it 'attrs should override the defaults' do
          described_class.new(NobelPrizeWinner.with_filters, {}, method: 'post').attrs.should == {novalidate: 'novalidate', method: 'post'}
        end
      end

      context ':theme' do
        it 'passes the theme to the inputs' do
          path = [Rails.root, 'app', 'views', 'with_filters', 'foo', 'filter']
          Dir.stub(:glob).and_return([])
          Dir.should_receive(:glob).
            with(File.join(*path, '_text.*')).
            and_return([File.join(*path, 'text')])

          ff = described_class.new(NobelPrizeWinner.with_filters, {}, theme: 'foo')
          ff.input(:first_name)

          ff.filters.first.to_partial_path.should == File.join('with_filters', 'foo', 'filter', 'text')
        end
      end
    end
  end

  describe '#hidden(name, options = {})' do
    it 'adds a hidden filter' do
      ff = described_class.new(NobelPrizeWinner.with_filters)
      ff.hidden(:hidden)

      ff.hidden_filters.length.should == 1
      ff.hidden_filters.first.should be_a_kind_of(WithFilters::Filter::Text)
      ff.hidden_filters.first.attrs[:type].should == 'hidden'
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

    context 'the type is :hidden' do
      it 'adds to the hidden_filters list' do
        ff.input(:foo, as: :hidden)

        ff.filters.should be_empty
        ff.hidden_filters[0].should be_a_kind_of(WithFilters::Filter::Text)
        ff.hidden_filters[0].attrs[:type].should == 'hidden'
      end
    end

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

    context 'the database field is text' do
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
      context ':collection' do
        it 'defaults to a select filter' do
          ff = described_class.new(FieldFormatTester.with_filters)
          ff.input(:text_field)

          ff.filters.first.should be_a_kind_of(WithFilters::Filter::Text)
          ff.filters.first.attrs[:type].should == 'text'
        end
      end

      context 'no :collection' do
        it 'defaults to a select filter' do
          ff = described_class.new(FieldFormatTester.with_filters)
          ff.input(:text_field, collection: 1..10)

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

  describe '#action(type, options = {})' do
    context 'type' do
      context ':submit' do
        it 'adds an action' do
          ff = described_class.new(NobelPrizeWinner.with_filters)
          ff.action(:submit)

          ff.actions.first.should be_a_kind_of(WithFilters::Action)
        end
      end

      context ':reset' do
        it 'adds an action' do
          ff = described_class.new(NobelPrizeWinner.with_filters)
          ff.action(:reset)

          ff.actions.first.should be_a_kind_of(WithFilters::Action)
        end
      end
    end
  end
end
