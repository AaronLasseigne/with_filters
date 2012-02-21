module WithFilters
  class Filter
    attr_reader :to_partial_path, :label, :label_options, :field_name, :field_value

    def initialize(name, namespace, options = {})
      @label         = options.delete(:label) || name.to_s.titleize
      @label_options = options.delete(:label_options) || {}

      @field_name      = "#{namespace}[#{name}]"
      @to_partial_path = self.class.name.underscore
    end
  end
end
