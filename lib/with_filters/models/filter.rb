module WithFilters
  class Filter
    attr_reader :partial_path, :label, :field_name, :field_value

    def initialize(name, namespace)
      @label      = name.to_s.titleize
      @field_name = "#{namespace}[#{name}]"

      @partial_path = self.class.name.underscore
    end
  end
end
