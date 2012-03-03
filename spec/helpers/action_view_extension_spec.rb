require 'spec_helper'

describe WithFilters::ActionViewExtension do
  describe '#filter_form_for(record, &block)' do
    it 'creates a form' do
      output = helper.filter_form_for(NobelPrizeWinner.with_filters.all) {}

      output.should have_selector('form[@novalidate="novalidate"]')
    end
  end

  describe '#with_filters_input_tag(filter)' do
    context 'types' do
      let(:options) {{
        class:       'input_class',
        label_attrs: {class: 'label_class'}
      }}

      context 'text' do
        let(:filter) {WithFilters::Filter::Text.new(:first_name, :foo, 'Aaron', options)}
        subject {helper.with_filters_input_tag(filter)}

        it 'has a label tag' do
          subject.should have_selector("label[text()='#{filter.label}']")

          filter.label_attrs.should_not be_empty
          filter.label_attrs.each do |k, v|
            subject.should have_selector("label[@#{k}='#{v}']")
          end
        end

        it 'has an input tag' do
          subject.should have_selector("input[@name='#{filter.field_name}']")
          subject.should have_selector("input[@value='#{filter.value}']")
          filter.attrs.should_not be_empty
          filter.attrs.each do |k, v|
            subject.should have_selector("input[@#{k}='#{v}']")
          end
        end
      end

      context 'radio' do
        let(:filter) {WithFilters::Filter::Radio.new(:gender, :foo, 'Male', options.merge(choices: [['Male', {class: 'choice_class'}], 'Female']))}
        subject {helper.with_filters_input_tag(filter)}

        it 'has a div tag as a label' do
          subject.should have_selector("div[text()='#{filter.label}']")

          filter.label_attrs.should_not be_empty
          filter.label_attrs.each do |k, v|
            subject.should have_selector("div[@#{k}='#{v}']")
          end
        end

        it 'has a label tag for each choice' do
          filter.choices.each do |choice|
            subject.should have_selector("label[text()='#{choice.label}']")
          end
        end

        it 'has an input tag for each choice' do
          subject.should have_selector("input[@name='#{filter.field_name}']")
          filter.choices.each do |choice|
            subject.should have_selector("input[@value='#{choice.value}']")
            if choice.value == filter.value
              subject.should have_selector("input[@checked='checked']")
            end
            choice.attrs.each do |k, v|
              subject.should have_selector("input[@#{k}='#{v}']")
            end
          end
        end
      end
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

          output.should have_selector("label[text()='Category']")
          choices.each do |choice|
            output.should have_selector("option[text()='#{choice}']")
            output.should have_selector("option[@value='#{choice}']")
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

  describe '#with_filters_select_tag(filter)' do
    let(:options) {{
      class:       'input_class',
      label_attrs: {class: 'label_class'}
    }}
    let(:filter) {WithFilters::Filter::Select.new(:gender, :foo, 'Male', options.merge(choices: [['Male', {class: 'choice_class'}], 'Female']))}
    subject {helper.with_filters_select_tag(filter)}

    it 'creates a select field' do
      subject.should have_selector("select[@name='#{filter.field_name}']")
    end

    it 'has an option for each choice' do
      filter.choices.each do |choice|
        subject.should have_selector("option[@value='#{choice.value}']")
        if choice.value == filter.value
          subject.should have_selector("option[@selected='selected']")
        end
        choice.attrs.each do |k, v|
          subject.should have_selector("option[@#{k}='#{v}']")
        end
      end
    end
  end
end
