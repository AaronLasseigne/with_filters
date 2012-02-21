module WithFilters
  class Filter
    attr_reader :to_partial_path, :label, :field_name, :field_value

    def initialize(name, namespace, options = {})
      @label = options.delete(:label) || name.to_s.titleize

      @field_name      = "#{namespace}[#{name}]"
      @to_partial_path = self.class.name.underscore
    end
  end
end
