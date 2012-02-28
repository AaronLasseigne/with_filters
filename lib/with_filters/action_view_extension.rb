module WithFilters
  module ActionViewExtension
    def filter_form_for(records, options = {})
      filter_form = WithFilters::FilterForm.new(records, params[records.with_filters_data[:param_namespace]] || {}, options)
      yield(filter_form)

      render(partial: filter_form.to_partial_path, locals: {filter_form: filter_form})
    end

    def with_filters_input_tag(filter)
      render(partial: filter.to_partial_path, locals: {filter: filter})
    end

    def with_filters_select_tag(filter)
      choices = filter.choices.map do |choice|
        html_attributes = choice.attrs.length > 0 ? ' ' + choice.attrs.map {|k, v| %(#{k.to_s}="#{v}")}.join(' ') : ''
        selected_attribute = choice.selected? ? ' selected="selected"' : ''

        %(<option value="#{ERB::Util.html_escape(choice.value)}"#{selected_attribute}#{html_attributes}>#{ERB::Util.html_escape(choice.label)}</option>)
      end

      select_tag(filter.field_name, choices.join("\n").html_safe, filter.attrs)
    end
  end
end
