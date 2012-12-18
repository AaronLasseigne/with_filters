require 'spec_helper'

shared_examples_for 'a specific text filter' do |input_type, filter_type|
  it "uses a #{filter_type} filter" do
    ff.input(input_type)
    
    expect(ff.filters.first).to be_a_kind_of(WithFilters::Filter::Text)
    expect(ff.filters.first.attrs[:type]).to eq filter_type
  end
end

describe WithFilters::FilterForm do
  describe '#initialize(records, params = {}, options = {})' do
    context 'defaults' do
      subject { described_class.new(NobelPrizeWinner.with_filters) }

      its(:attrs)           { should == {novalidate: 'novalidate', method: 'get'} }
      its(:to_partial_path) { should == File.join('with_filters', 'filter_form') }
      its(:param_namespace) { should be :nobel_prize_winners }
      its(:filters)         { should be_empty }
      its(:hidden_filters)  { should be_empty }
      its(:actions)         { should be_empty }
    end

    context 'options' do
      context ':attrs' do
        it 'attrs should override the defaults' do
          expect(
            described_class.new(NobelPrizeWinner.with_filters, {}, method: 'post').attrs
          ).to eq({
            novalidate: 'novalidate',
            method:     'post'
          })
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

          expect(
            ff.filters.first.to_partial_path
          ).to eq File.join('with_filters', 'foo', 'filter', 'text')
        end
      end
    end
  end

  describe '#hidden(name, options = {})' do
    it 'adds a hidden filter' do
      ff = described_class.new(NobelPrizeWinner.with_filters)
      ff.hidden(:hidden)

      expect(ff.hidden_filters).to have(1).filter
      expect(ff.hidden_filters.first).to be_a_kind_of(WithFilters::Filter::Text)
      expect(ff.hidden_filters.first.attrs[:type]).to eq 'hidden'
    end
  end

  describe '#input(name, options = {})' do
    it 'adds a filter' do
      label = 'Given Name'
      ff = described_class.new(NobelPrizeWinner.with_filters)
      ff.input(:first_name, label: label)

      expect(ff.filters).to have(1).filter
      expect(ff.filters.first).to be_a_kind_of(WithFilters::Filter::Base)
      expect(ff.filters.first.label).to eq label
    end

    let(:ff) { described_class.new(FieldFormatTester.with_filters) }

    context 'options' do
      context ':collection' do
        it 'defaults to a select filter' do
          ff = described_class.new(FieldFormatTester.with_filters)
          ff.input(:text_field)

          expect(ff.filters.first).to be_a_kind_of(WithFilters::Filter::Text)
          expect(ff.filters.first.attrs[:type]).to eq 'text'
        end
      end

      context 'no :collection' do
        it 'defaults to a select filter' do
          ff = described_class.new(FieldFormatTester.with_filters)
          ff.input(:text_field, collection: 1..10)

          expect(ff.filters.first).to be_a_kind_of(WithFilters::Filter::Select)
        end
      end

      context 'the type is :hidden' do
        it 'adds to the hidden_filters list' do
          ff.input(:foo, as: :hidden)

          expect(ff.filters).to be_empty
          expect(ff.hidden_filters.first).to be_a_kind_of(WithFilters::Filter::Text)
          expect(ff.hidden_filters.first.attrs[:type]).to eq 'hidden'
        end
      end
    end

    context 'the database field' do
      context 'is an integer' do
        it_behaves_like 'a specific text filter', :integer_field, 'number'
      end

      context 'is a float' do
        it_behaves_like 'a specific text filter', :float_field, 'number'
      end

      context 'is a decimal' do
        it_behaves_like 'a specific text filter', :decimal_field, 'number'
      end

      context 'is a date' do
        it_behaves_like 'a specific text filter', :date_field, 'date'
      end

      context 'is a time' do
        it_behaves_like 'a specific text filter', :time_field, 'time'
      end

      context 'is a datetime' do
        it_behaves_like 'a specific text filter', :datetime_field, 'datetime'
      end

      context 'is a timestamp' do
        it_behaves_like 'a specific text filter', :timestamp_field, 'datetime'
      end

      context 'is a boolean' do
        it 'uses a checkbox filter' do
          ff.input(:boolean_field)

          expect(ff.filters.first).to be_a_kind_of(WithFilters::Filter::CheckBox)
          expect(ff.filters.first.attrs[:type]).to eq 'checkbox'
        end
      end

      context 'is text' do
        context 'and the name includes "email"' do
          it_behaves_like 'a specific text filter', :email_field, 'email'
        end

        context 'and the name includes "phone"' do
          it_behaves_like 'a specific text filter', :phone_field, 'tel'
        end

        context 'and the name includes "url"' do
          it_behaves_like 'a specific text filter', :url_field, 'url'
        end
      end
    end
  end

  describe '#input_range(name, options = {})' do
    it 'adds a ranged filter' do
      label = 'Awarded'
      ff = described_class.new(NobelPrizeWinner.with_filters)
      ff.input_range(:year, label: label)

      expect(ff.filters).to have(1).filter
      expect(ff.filters.first).to be_a_kind_of(WithFilters::Filter::BaseRange)
      expect(ff.filters.first.start.label).to eq label
    end
  end

  describe '#action(type, options = {})' do
    context 'type' do
      context ':submit' do
        it 'adds an action' do
          ff = described_class.new(NobelPrizeWinner.with_filters)
          ff.action(:submit)

          expect(ff.actions.first).to be_a_kind_of(WithFilters::Action)
        end
      end

      context ':reset' do
        it 'adds an action' do
          ff = described_class.new(NobelPrizeWinner.with_filters)
          ff.action(:reset)

          expect(ff.actions.first).to be_a_kind_of(WithFilters::Action)
        end
      end
    end
  end
end
