require 'spec_helper'

describe WithFilters::ActionViewExtension do
  describe '#filter_form_for(record, &block)' do
    it 'creates a form' do
      output = helper.filter_form_for(NobelPrizeWinner.with_filters.all) {}

      output.should have_selector('form[@novalidate="novalidate"]')
    end

    describe '#input' do
      it 'default case' do
        output = helper.filter_form_for(NobelPrizeWinner.with_filters.all) do |f|
          f.input :first_name
        end

        output.should have_selector('label[text()="First Name"]')
        output.should have_selector('input[@name="nobel_prize_winners[first_name]"]')
      end
      
      context 'options' do
        context ':label_attrs' do
          it 'adds attrs to the label_tag' do
            output = helper.filter_form_for(NobelPrizeWinner.with_filters.all) do |f|
              f.input :first_name, label_attrs: {class: 'label_class'}
            end

            output.should have_selector('label.label_class')
          end
        end

        context ':choices' do
          it 'outputs all choices' do
            choices = ['Chemistry', 'Literature', 'Peace', 'Physics', 'Physiology or Medicine']
            output = helper.filter_form_for(NobelPrize.with_filters.all) do |f|
              f.input :category, choices: choices
            end

            output.should have_selector("div[text()='Category']")
            choices.each do |choice|
              output.should have_selector("label[text()='#{choice}']")
              output.should have_selector("input[@value='#{choice}']")
            end
          end
        end

        context 'everything else' do
          it 'adds attrs to the input' do
            output = helper.filter_form_for(NobelPrizeWinner.with_filters.all) do |f|
              f.input :first_name, class: 'input_class'
            end

            output.should have_selector('input.input_class')
          end
        end
      end

      context 'param value is available' do
        it 'creates an input with a value' do
          helper.stub(:params).and_return({nobel_prize_winners: {first_name: 'Albert'}})
          output = helper.filter_form_for(NobelPrizeWinner.with_filters.all) do |f|
            f.input :first_name
          end

          output.should have_selector('input[@value="Albert"]')
        end
      end
    end
  end
end
