module WithFilters
  module ActionViewExtension
    def filter_form_for(records, options = {})
      f = WithFilters::FilterForm.new(records, params[records.with_filters_data[:param_namespace]] || {}, options)
      yield(f)

      render(partial: f.to_partial_path, locals: {filter_form: f})
    end

    def with_filters_input_tag(filter)
      render(partial: filter.to_partial_path, locals: {filter: filter})
    end
  end
end
