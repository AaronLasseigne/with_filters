module WithFilters
  module ActionViewExtension
    def filter_form_for(records, options = {})
      f = WithFilters::FilterForm.new(records)
      yield(f)

      self.render(partial: f.partial_path, locals: {filter_form: f})
    end
  end
end
