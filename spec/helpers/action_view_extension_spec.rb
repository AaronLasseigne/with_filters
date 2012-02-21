require 'spec_helper'

describe WithFilters::ActionViewExtension do
  describe '#filter_form_for(record, &block)' do
    subject {helper.filter_form_for(NobelPrizeWinner.with_filters.all) {}}

    it 'should output a form' do
      subject.should have_selector('form[@novalidate="novalidate"]')
    end

    it 'can add a filter' do
      output = helper.filter_form_for(NobelPrizeWinner.with_filters.all) do |f|
        f.input :first_name
      end

      output.should have_selector('label[text()="First Name"]')
      output.should have_selector('input[@name="nobel_prize_winners[first_name]"]')
    end
  end
end
