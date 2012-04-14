require 'spec_helper'

describe WithFilters::ActionViewExtension do
  describe '#filter_form_for(record, &block)' do
    it 'creates a form' do
      output = helper.filter_form_for(NobelPrizeWinner.with_filters) {}

      output.should have_selector('form[@novalidate="novalidate"]')
    end
  end

  describe '#with_filters_hidden(hidden_filters)' do
    it 'outputs hidden input tags' do
      hidden1 = WithFilters::Filter::Text.new(:hidden1, :foo, 1, {})
      hidden2 = WithFilters::Filter::Text.new(:hidden2, :foo, 2, {})

      output = helper.with_filters_hidden([hidden1, hidden2])

      output.should have_selector('input[type="hidden"][value="1"]')
      output.should have_selector('input[type="hidden"][value="2"]')
    end
  end

  describe '#with_filters_input(filter)' do
    context 'with a single input' do
      context 'types' do
        let(:options) {{
          class:       'input_class',
          label_attrs: {class: 'label_class'}
        }}

        context 'text' do
          let(:filter) {WithFilters::Filter::Text.new(:first_name, :foo, 'Aaron', options)}
          subject {helper.with_filters_input(filter)}

          it 'has a label tag' do
            subject.should have_selector('label')
          end

          it 'has an input tag' do
            subject.should have_selector("input[@name='#{filter.field_name}']")
          end
        end

        context 'radio' do
          let(:filter) {WithFilters::Filter::Radio.new(:gender, :foo, 'Male', options.merge(collection: [['Male', {class: 'choice_class'}], 'Female']))}
          subject {helper.with_filters_input(filter)}

          it 'has a label for the group' do
            subject.should have_selector("div[text()='#{filter.label}']")
          end

          it 'has a label tag for each choice' do
            filter.collection.each do |choice|
              subject.should have_selector("label[text()='#{choice.label}']")
            end
          end

          it 'has an input tag for each choice' do
            subject.should have_selector("input[@type='radio']")
            filter.collection.each do |choice|
              subject.should have_selector("input[@name='#{choice.field_name}']")
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

        context 'check_box' do
          let(:collection) {['Chemistry', 'Literature', 'Peace', 'Physics', 'Physiology or Medicine']}

          context 'without collection' do
            let(:filter) {WithFilters::Filter::CheckBox.new(:gender, :foo, 'on')}
            subject {helper.with_filters_input(filter)}

            it 'has a label tag' do
              subject.should have_selector('label')
            end

            it 'has an input tag' do
              subject.should have_selector("input[@type='checkbox']")
              subject.should have_selector("input[@name='#{filter.field_name}']")
              subject.should have_selector("input[@value='#{filter.value}']")
              subject.should have_selector("input[@checked='checked']")
            end
          end

          context 'with collection' do
            let(:filter) {WithFilters::Filter::CheckBox.new(:gender, :foo, ['Chemistry', 'Peace'], options.merge(collection: collection))}
            subject {helper.with_filters_input(filter)}

            it 'has a label for the group' do
              subject.should have_selector("div[text()='#{filter.label}']")
            end

            it 'has a label tag for each choice' do
              filter.collection.each do |choice|
                subject.should have_selector("label[text()='#{choice.label}']")
              end
            end

            it 'has an input tag for each choice' do
              subject.should have_selector("input[@type='checkbox']")
              filter.collection.each do |choice|
                subject.should have_selector("input[@name='#{choice.field_name}']")
                subject.should have_selector("input[@value='#{choice.value}']")
                if filter.value.include?(choice.value)
                  subject.should have_selector("input[@checked='checked']")
                end
              end
            end
          end
        end
      end

      context 'with ranged inputs' do
        context 'types' do
          context 'text' do
            let(:filter) {WithFilters::Filter::TextRange.new(:year, :foo, {start: 1900, stop: 2000})}
            subject {helper.with_filters_input(filter)}

            context 'start' do
              it 'has a label tag' do
                subject.should have_selector("label[text()='#{filter.start.label}']")
              end

              it 'has an input tag' do
                subject.should have_selector("input[@name='#{filter.start.field_name}']")
                subject.should have_selector("input[@value='#{filter.start.value}']")
              end
            end

            context 'stop' do
              it 'has a label tag' do
                subject.should have_selector("label[text()='#{filter.stop.label}']")
              end

              it 'has an input tag' do
                subject.should have_selector("input[@name='#{filter.stop.field_name}']")
                subject.should have_selector("input[@value='#{filter.stop.value}']")
              end
            end
          end

          context 'select' do
            let(:filter) {WithFilters::Filter::SelectRange.new(:year, :foo, {start: 1900, stop: 1905}, collection: 1900..1910)}
            subject {helper.with_filters_input(filter)}

            context 'start' do
              it 'has a label tag' do
                subject.should have_selector("label[text()='#{filter.start.label}']")
              end
            end

            context 'stop' do
              it 'has a label tag' do
                subject.should have_selector("label[text()='#{filter.stop.label}']")
              end
            end
          end
        end
      end
    end
    
    context 'options' do
      context ':label_attrs' do
        it 'adds attrs to the label_tag' do
          output = helper.filter_form_for(NobelPrizeWinner.with_filters) do |f|
            f.input :first_name, label_attrs: {class: 'label_class'}
          end

          output.should have_selector('label.label_class')
        end
      end

      context ':collection' do
        it 'outputs all collection' do
          collection = ['Chemistry', 'Literature', 'Peace', 'Physics', 'Physiology or Medicine']
          output = helper.filter_form_for(NobelPrize.with_filters) do |f|
            f.input :category, collection: collection
          end

          output.should have_selector("label[text()='Category']")
          collection.each do |choice|
            output.should have_selector("option[text()='#{choice}']")
            output.should have_selector("option[@value='#{choice}']")
          end
        end
      end

      context 'everything else' do
        it 'adds attrs to the input' do
          output = helper.filter_form_for(NobelPrizeWinner.with_filters) do |f|
            f.input :first_name, class: 'input_class'
          end

          output.should have_selector('input.input_class')
        end
      end
    end

    context 'param value is available' do
      it 'creates an input with a value' do
        helper.stub(:params).and_return({nobel_prize_winners: {first_name: 'Albert'}})
        output = helper.filter_form_for(NobelPrizeWinner.with_filters) do |f|
          f.input :first_name
        end

        output.should have_selector('input[@value="Albert"]')
      end
    end
  end

  describe '#with_filters_label_tag(filter)' do
    let(:filter) {WithFilters::Filter::Text.new(:first_name, :foo, 'Aaron', label_attrs: {class: 'bar'})}
    subject {helper.with_filters_label_tag(filter)}

    it 'has the correct label text' do
      subject.should have_selector("label[text()='#{filter.label}']")
    end

    it 'has the correct for attribute' do
      subject.should have_selector(%Q{label[for="#{filter.field_name.match(/^(.*)\[(.*)\]$/).captures.join('_')}"]})
    end

    it 'has the correct attributes' do
      filter.label_attrs.should_not be_empty
      filter.label_attrs.each do |k, v|
        subject.should have_selector("label[@#{k}='#{v}']")
      end
    end
  end

  describe '#with_filters_label(filter)' do
    context 'a tag with a single label' do
      let(:filter) {WithFilters::Filter::Text.new(:first_name, :foo, 'Aaron', label_attrs: {class: 'bar'})}
      subject {helper.with_filters_label(filter)}

      it 'creates a label tag' do
        subject.should have_selector("label[text()='#{filter.label}']")
      end
    end

    context 'a group of tags with individual labels and one form label' do
      let(:options) {{label_attrs: {class: 'label_class'}}}
      let(:filter) {WithFilters::Filter::Radio.new(:gender, :foo, 'Male', options.merge(collection: ['Male', 'Female']))}
      subject {helper.with_filters_label(filter)}

      it 'creates a div to act as a label tag for the group' do
        subject.should have_selector("div[text()='#{filter.label}']")

        filter.label_attrs.should_not be_empty
        filter.label_attrs.each do |k, v|
          subject.should have_selector("div[@#{k}='#{v}']")
        end
      end
    end
  end

  describe '#with_filters_text_field_tag(filter)' do
    let(:options) {{
      class:       'input_class',
      label_attrs: {class: 'label_class'}
    }}
    let(:filter) {WithFilters::Filter::Text.new(:first_name, :foo, 'Aaron', options)}
    subject {helper.with_filters_text_field_tag(filter)}

    it 'has an input tag' do
      subject.should have_selector("input[@name='#{filter.field_name}']")
      subject.should have_selector("input[@value='#{filter.value}']")
      filter.attrs.should_not be_empty
      filter.attrs.each do |k, v|
        subject.should have_selector("input[@#{k}='#{v}']")
      end
    end
  end

  describe '#with_filters_select_tag(filter)' do
    let(:options) {{
      class:       'input_class',
      label_attrs: {class: 'label_class'}
    }}
    let(:filter) {WithFilters::Filter::Select.new(:gender, :foo, 'Male', options.merge(collection: [['Male', {class: 'choice_class'}], 'Female']))}
    subject {helper.with_filters_select_tag(filter)}

    it 'creates a select field' do
      subject.should have_selector("select[@name='#{filter.field_name}']")
    end

    it 'has an option for each choice' do
      filter.collection.each do |choice|
        subject.should have_selector("option[@value='#{choice.value}']")
        if choice.value == filter.value
          subject.should have_selector("option[@selected='selected']")
        end
        choice.attrs.each do |k, v|
          subject.should have_selector("option[@#{k}='#{v}']")
        end
      end
    end

    context 'where :collection is a String' do
      let(:filter) {WithFilters::Filter::Select.new(:gender, :foo, 'Male', collection: '<option>Male</option><option value="1">Female</option>')}
      subject {helper.with_filters_select_tag(filter)}

      context 'option does not contain a value attribute' do
        it 'should mark an option as selected' do
          subject.should have_selector('option[@selected="selected"][text()="Male"]')
          subject.should have_selector('option[text()="Female"]')
        end
      end

      context 'option contains a value attribute' do
        let(:filter) {WithFilters::Filter::Select.new(:gender, :foo, 1, collection: '<option>Male</option><option value="1">Female</option>')}
        subject {helper.with_filters_select_tag(filter)}

        it 'should mark an option as selected' do
          subject.should have_selector('option[text()="Male"]')
          subject.should have_selector('option[@selected="selected"][text()="Female"]')
        end
      end
    end
  end

  describe '#with_filters_action_tag(action)' do
    context 'action' do
      context ':submit' do
        it 'returns a submit button' do
          helper.with_filters_action_tag(WithFilters::Action.new(:submit)).should have_selector('input[type="submit"]')
        end
      end

      context ':reset' do
        it 'returns a reset button' do
          helper.with_filters_action_tag(WithFilters::Action.new(:reset)).should have_selector('button[type="reset"]')
        end
      end
    end
  end
end
